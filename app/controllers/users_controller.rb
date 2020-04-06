# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:destroy]
  # before_action :require_user!

  # GET /users
  def index
    @users = User.all.page(params[:page])
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
      UserSignInMailer.send_invite_email(@user).deliver
      redirect_to :users, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # DELETE /users/1
  def destroy
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
end
