class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      sign_in_and_redirect user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => user.name) if is_navigational_format?
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to signup_url #new_user_registration_url #signup_url
    end
  end

  def failure
    redirect_to root_path
  end
end
