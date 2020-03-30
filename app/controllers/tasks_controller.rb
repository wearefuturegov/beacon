class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:contact, :user).page(params[:page])
  end

  def show
  end

  def create
    @contact = Contact.find(params[:contact_id])
    @task = Task.new(task_params.merge(contact: @contact))
    unless @task.valid?
      @users = User.all
      render 'contacts/show'
      return
    end

    @task.save
    redirect_to contact_path(@contact)
  end

  private
    def task_params
      params.require(:task).permit(:name, :due_by, :user_id)
    end
end
