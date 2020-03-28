class UsersController < ApplicationController
  require 'auth0'

  before_action :set_user, only: [:destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.invited = DateTime.now

    create_auth0_user

    if @user.save
      UserSignInMailer.send_invite_email(@user).deliver
      redirect_to :users, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # DELETE /users/1
  def destroy
    destroy_auth0_user

    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :admin)
    end

    def auth0_client
      @auth0_client ||= Auth0Client.new(
        client_id: ENV['AUTH0_CLIENT_ID'],
        client_secret: ENV['AUTH0_CLIENT_SECRET'],
        # If you pass in a client_secret value, the SDK will automatically try to get a 
        # Management API token for this application. Make sure your Application can make a 
        # Client Credentials grant (Application settings in Auth0 > Advanced > Grant Types
        # tab) and that the Application is authorized for the Management API:
        # https://auth0.com/docs/api-auth/config/using-the-auth0-dashboard
        #
        # Otherwise, you can pass in a Management API token directly for testing or temporary
        # access using the key below. 
        #token: ENV['AUTH0_MANAGEMENT_TOKEN'],
        domain: ENV['AUTH0_DOMAIN'],
        api_version: 2,
        timeout: 15 # optional, defaults to 10
      )
    end

    def create_auth0_user
      begin
        auth0_client.create_user(
          @user.email,
          email: @user.email,
          connection: 'email'
        )
      rescue Exception => exc
        logger.error("Failed to create auth0 user: #{exc.message}")
        raise 'Failed to create user in remote user management system'
      end
    end

    def destroy_auth0_user
      begin
        auth0_user = auth0_client.users_by_email(@user.email).first
        auth0_client.delete_user(auth0_user['user_id'])
      rescue NoMethodError => exc
        logger.error("Failed to delete auth0 user: #{exc.message}")
        raise 'Failed to delete user in remote user management system'
      end
    end
end
