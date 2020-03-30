class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:contact, :user).page(params[:page])
  end
end
