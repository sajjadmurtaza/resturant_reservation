class CodeAuthenticationsController < ApplicationController
  

  def index
    if params[:code].present?
      if current_user.authenticate_otp(params[:code].to_i)
        user = User.find_by_id(current_user.id)
        user.active_user = true
        user.save
        redirect_to restaurants_path
      else
        redirect_to code_authentications_path
      end
    end
  end

  def resend_code
    code = current_user.otp_code
    TWILIO_CLIENT.account.messages.create({
                                              :from => '+1 618-596-3852',
                                              :to => current_user.phone,
                                              :body => "Please enter #{code} ",
                                          })
   
  end

end
