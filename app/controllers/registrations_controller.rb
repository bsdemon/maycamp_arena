class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(
      :login,
      :name,
      :city,
      :email,
      :unencrypted_password,
      :unencrypted_password_confirmation)
  end
end

