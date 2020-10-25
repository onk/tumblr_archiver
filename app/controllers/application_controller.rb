class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    unless defined?(@current_user)
      @current_user = User.find_by(id: session[:user_id])
    end
    @current_user
  end
  helper_method :current_user
end
