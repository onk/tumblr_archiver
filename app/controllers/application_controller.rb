class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  protect_from_forgery with: :exception

  def current_user
    unless defined?(@current_user)
      @current_user = User.find_by(id: session[:user_id])
    end
    @current_user
  end
  helper_method :current_user
end
