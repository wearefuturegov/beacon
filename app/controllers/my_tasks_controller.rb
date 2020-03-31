class MyTasksController < ApplicationController
  include ParamsConcern
  
  def index
    @tasks = current_user.tasks.includes(:contact, :user).page(params[:page])
    @users = [current_user]
  end
end
