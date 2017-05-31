class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # before_action :authenticate_user!
  protect_from_forgery with: :exception
  helper_method :current_resource


  def after_sign_in_path_for(resource)
    return restaurants_path if resource.class.name == 'User'
    reservations_path
  end
  
  def current_resource
    @current_resource ||= (current_user || current_admin_user || current_restaurant)
  end

  def user_signed_in
    unless current_resource.present?
      redirect_to new_restaurant_session_path
    end
  end
end
