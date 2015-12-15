class Users::RegistrationsController < Devise::RegistrationsController

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :login,
      :name,
      :city,
      :email,
      :unencrypted_password,
      :unencrypted_password_confirmation,
      :provider,
      :uid)
  end
end
