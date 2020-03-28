class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: 'camden', password: 'camden'
  helper_method :current_user, :authenticate_user!

  def authenticate_user!
    redirect_to '/' unless current_user
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception => e
      nil
    end
  end
end
