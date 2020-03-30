class MyTasksController < ApplicationController
  def index
    @tasks = current_user.tasks.includes(:contact, :user).page(params[:page])
  end
end
