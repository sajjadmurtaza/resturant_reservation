class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  before_filter :deactivate_user, only: [:destroy]

  private
  def deactivate_user
    current_user.update_column :active_user, false
  end
end
