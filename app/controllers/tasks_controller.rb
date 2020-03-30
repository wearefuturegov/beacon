class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:contact, :user).page(params[:page])
  end

  def create
    @contact = Contact.find(params[:contact_id])
    @note = @contact.tasks.create(task_params.merge(user: current_user))
    redirect_to contact_path(@contact)
  end

  private
    def task_params
      params.require(:task).permit(:name)
    end
end
