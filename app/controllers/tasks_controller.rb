class TasksController < ApplicationController
  include ParamsConcern
  before_action :set_task, only: [:show, :edit, :update]
  helper_method :get_param
  
  def index
    @users = User.all
    if params['search_user'].present?
      selected_user = User.find(params['search_user'])
      @tasks = selected_user.tasks.includes(:contact, :user).page(params[:page])
    else      
      @tasks = Task.includes(:contact, :user)
    end
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

  def edit
    @users = User.all
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: 'Task was successfully updated.'
    else
      @users = User.all
      render :edit
    end
  end

  private
    def set_task
      @task = Task.find(params[:id])
      @contact = @task.contact
    end

    def task_params
      params.require(:task).permit(:name, :due_by, :user_id, :category)
    end
end
