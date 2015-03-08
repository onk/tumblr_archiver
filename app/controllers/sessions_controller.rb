class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.create_or_update_with_omniauth(auth)

    reset_session
    session[:user_id] = user.id

    redirect_to root_path, notice: "Signed In!"
  end

  def destroy
    reset_session
    session[:user_id] = nil

    redirect_to root_path, notice: "Signed Out!"
  end
end
