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
      render 'contacts/show_tasks'
      return
    end

    @task.save
    redirect_to controller: :contacts, action: :show_tasks, id: @contact.id
  end

  private
    def task_params
      params.require(:task).permit(:name, :due_by, :user_id, :category)
    end
end
