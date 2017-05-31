class RestaurantsController < ApplicationController
  before_filter :authenticate_admin_user! , :only => [:create,:new]
  before_filter :user_signed_in
  before_filter :set_restaurant, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.present?
      session[:zip_code] = params[:zip_code] if params[:zip_code]
      @zip_code = (session[:zip_code] || params[:zip_code]).present? ? ZipCode.find_or_create_by(code: (params[:zip_code] || session[:zip_code])) : current_user.zip_codes.last
      @restaurants = @zip_code.restaurants
    else
      @restaurants = Restaurant.all
    end
  end



  def show
  end

  def new
    @restaurant = Restaurant.new
  end

  def edit
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    
    @restaurant.save
    if  params[:code].present?
      @restaurant.zip_code = ZipCode.find_or_create_by(code: params[:code])
      @restaurant.save
    end
    redirect_to restaurants_path
  end

  def update
    @restaurant.update!(restaurant_params)
    if  params[:code].present?
      @restaurant.zip_code = ZipCode.find_or_create_by(code: params[:code])
      @restaurant.save
    end
    redirect_to @restaurant
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_path
  end
  private

    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :phone, :address, :email, :password, :password_confirmation, :image)
    end

end
