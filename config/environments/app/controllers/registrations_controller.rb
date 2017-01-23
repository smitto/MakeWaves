class RegistrationsController < Devise::RegistrationsController

  private

  # Permits specified parameters through Devise
  def sign_up_params
    params.require(:user).permit(:title, :email, :password, :password_confirmation, :role, :thumbnail, :description)
  end

  # Permits specified parameters through Devise
  def account_update_params
    params.fetch(:user).permit(:title, :email, :password, :password_confirmation, :thumbnail, :description, :current_password)
  end
end
