class Users::RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
before_filter :configure_account_update_params, only: [:update]


  # #GET /resource/sign_up
  # def new
  #   super
  # end

  #POST /resource
  def create
    user = User.find_by(user_params) || User.new(user_params)
    zip_code = ZipCode.find_or_create_by(code: params[:code])
    session[:zip_code] = params[:code]
    user.zip_codes << zip_code if !user.zip_codes.include? zip_code

    if user.new_record?
      user.save
      code = user.otp_code
      user.authenticate_otp(code, drift: 120)
      begin
      TWILIO_CLIENT.account.messages.create({
                                                :from => '+1 618-596-3852',
                                                :to => user.phone,
                                                :body => "Please enter #{code} ",
                                            })
      sign_up :user, user
      redirect_to code_authentications_path
    rescue => ex
      user.destroy
      redirect_to :back, notice: ex.message
    end
    else
      sign_in :user, user
      redirect_to restaurants_path
    end

  end

  #
  # #GET /resource/edit

  def edit
    super
  end
  #
  # #PUT /resource
  def update
    super
    unless params[:code].blank?
      resource.zip_codes << ZipCode.find_or_create_by(code: params[:code])
      resource.save
    end
  end
  #
  # #DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # def generate_code
  #   if resource.persisted? # user is created successfuly
  #     $code = SecureRandom.random_number(10000)
  #   end
  # end

  def after_sign_in_path_for(resource)
    code_authentications_path
  end

  protected


  #You can put the params you want to permit in the empty array.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:phone) }
  end

  #You can put the params you want to permit in the empty array.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:phone) }
  end

  def user_params
    params.require(:user).permit(:phone)
  end

end
