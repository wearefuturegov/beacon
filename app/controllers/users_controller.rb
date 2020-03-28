class UsersController < ApplicationController

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
    if @user.save
      redirect_to :users, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :admin)
  end
end