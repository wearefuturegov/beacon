class MyTasksController < ApplicationController
  before_action :require_user!

  def index
    @tasks = current_user.tasks.includes(:contact, :user).page(params[:page])
  end
end
