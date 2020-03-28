class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    @user = User.omniauth(auth_hash)
    reset_session
    session[:user_id] = @user.id
    redirect_to request.env['omniauth.origin'] || root_path,
                notice: 'Signed in!'
  end

  def failure
    @error_msg = request.params['message']
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Signed out!'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
