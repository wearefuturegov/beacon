class UsersController < ApplicationController

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @contact = User.new
  end
end