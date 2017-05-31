class ReservationsController < ApplicationController
  # skip_before_filter :authenticate_user! , :only => [:index]
  #before_filter :user_signed_in, except: [:show,:cancel]
  before_filter :set_reservation, only: [:show, :edit, :update, :destroy,:cancel,:activate]

  def index
    if current_user.present?
      @reservations = current_user.reservations.page( params[:page]).per(10)
    elsif current_restaurant.present?
      @reservations=current_restaurant.reservations.twelve_hour_old.page( params[:page]).per(10)
    else
      @reservations = Reservation.search(params[:restaurant_id],"#{params[:month]} #{params[:year]}").page(params[:page]).per(10)
      respond_to do |format|
        format.html
        format.js
        format.csv {
          @reservations = Reservation.search(params[:restaurant_id],"#{params[:month]} #{params[:year]}")
          send_data @reservations.to_csv(params[:est])
        }
      end
    end
  end

  def active
    @reservations=current_restaurant.reservations.today.active.includes(:user)
  end

  def activate
     @reservation.update(active: true)
     code = @reservation.user.otp_code
     @reservation.user.authenticate_otp(code, drift: 20000)
     @url = URI::encode(cancel_reservation_url(@reservation, access_token: code))
     body = "Your table is now ready, please come to the host stand to be seated.\n
           If your plans change please click here #{@url} to cancel your reservation.\n
           Sent from seated-app.com"
     TWILIO_CLIENT.account.messages.create({
        :from => '+1 618-596-3852',
        :to => @reservation.user.phone,
        :body => body,
        })
     redirect_to reservations_path
  end
  
  def cancel
    if @reservation.user.authenticate_otp(params[:access_token].to_i)
      @reservation.update(confirmed: false,active: false)
      redirect_to @reservation
    else  
    redirect_to reservations_path(unauthorize: true)
    end
  end

  def show
   
  end

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @reservation = Reservation.new
  end

  def edit
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to @reservation
    end
  end

  def update
    if params[:reservation][:confirmed]
      code = @reservation.user.otp_code
      @reservation.user.authenticate_otp(code, drift: 20000)
      @url = URI::encode(cancel_reservation_url(@reservation, access_token: code))
      @reservation.update(reservation_params)
      if @reservation.wait_time.strip == 'IMMEDIATE SEATING'
       wait_time = "We currently have no wait time. When you arrive, please check in at the host stand."
      else
        wait_time = "Your table will be ready for you in approximately #{@reservation.wait_time} minutes. Please arrive early."
      end
      
      body = "Thank you for choosing #{@reservation.restaurant.name}.\n
              We have you booked for a table of #{@reservation.number_of_people}\n
              #{wait_time}\n
              If your plans change please click here #{@url} to cancel your reservation.\n
              Sent from seated-app.com"
      if eval(params[:reservation][:confirmed])== true
        TWILIO_CLIENT.account.messages.create({
          :from => '+1 618-596-3852',
          :to => @reservation.user.phone,
          :body => body
          })
      end

    else
      @reservation.update(reservation_params)

    end
    redirect_to reservations_path
  end

  def destroy
    @reservation.destroy
  end

  private
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:user_id, :wait_time, :party_name, :number_of_people, :estimated_time, :party_time, :restaurant_id, :active, :confirmed)
  end
end
