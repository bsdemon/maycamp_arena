# encoding: utf-8

# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  layout "main"

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # render new.rhtml
  def new
  end

  def create
    resource = User.find_by_email(params[:user][:email])
    if resource.valid_password?(params[:user][:password])
      sign_in :user, resource
      if session[:back]
        back_path = session[:back]
        session[:back] = nil
        redirect_to back_path
      else
        redirect_to root_path
      end
    else
      flash.now[:error] = "Неуспешно влизане с потребителско име '#{resource[:email]}'"
      logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"

      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logoff
    flash[:notice] = "Вие излязохте успешно от системата."
    redirect_to root_path
  end

  def invalid_login_attempt
    flash.now[:error] = "Неуспешно влизане с потребителско име '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
