# The registrations controller, specifying what user parameters may be set during signup and editing.
class RegistrationsController < Devise::RegistrationsController

  private

  # The specific parameters for a user to set when setting up
  def sign_up_params
    params.require(:user).permit(:title, :email, :password, :password_confirmation, :role, :thumbnail, :description)
  end

  # The specific parameters that may be set for a user when updating
  def account_update_params
    params.fetch(:user).permit(:title, :email, :password, :password_confirmation, :thumbnail, :description, :current_password)
  end
end
