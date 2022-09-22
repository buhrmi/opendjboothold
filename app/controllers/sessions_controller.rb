class SessionsController < ApplicationController
  def new
    if params[:provider]
      # Just render the ERB template that automatically makes a POST request to /auth/:provider
      render layout: false
    end
  end

  def create
    if request.env['omniauth.auth'].present?
      create_from_omniauth
    else
      create_from_email
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end

  private
  def create_from_omniauth
    identity = Identity.from_omniauth!(request.env["omniauth.auth"])
    session[:user_id] = identity.user.id
    flash[:notice] = "You have been logged in."

    render layout: false
  end

  def create_from_email
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "You have been logged in."
      redirect_to current_user
    else
      flash[:error] = "Email or password is incorrect. Please try again."
      redirect_to new_session_path
    end
  end
end