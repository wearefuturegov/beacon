class NeedsController < ApplicationController
  include ParamsConcern
  before_action :set_need, only: [:show, :edit, :update]
  before_action :set_contact, only: [:new, :create]

  helper_method :get_param

  def index
    @users = User.all

    # temporary static filters to solve performance issues
    if params["needs_list"].present?
      if params["needs_list"] == 'my_to_do'
        @needs = Need.where(user_id: current_user.id, completed_on: nil).order(created_at: :desc).page(params[:page])
      elsif params["needs_list"] == 'all_unmet'
        @needs = Need.where(user_id: nil, completed_on: nil).order(created_at: :desc).page(params[:page])
      elsif params["needs_list"] == 'all_needs'
        @needs = Need.order(created_at: :desc).page(params[:page])
      end
      return
    end

    if params['search_user'].present?
      selected_user = User.find(params['search_user'])
      @needs = selected_user.needs.includes(:contact, :user).page(params[:page])
    else
      @needs = Need.includes(:contact, :user)
    end
  end

  def show
  end

  def new
    @needs = Needs.new
  end

  def create
    needs_params["needs_list"].each do |_, value|
      if value["active"] == "true"
        need_category = value["name"].humanize
        need_description = value["description"]
        if need_description.blank?
          need_description = "#{@contact.name} needs #{need_category}"
        end

        @contact.needs.build(category: need_category, name: need_description, due_by: DateTime.now + 7.days).save
      end
    end

    if needs_params["other_need"]
      @contact.needs.build(category: "Other", name: needs_params["other_need"], due_by: DateTime.now + 7.days).save
    end

    redirect_to controller: :contacts, action: :show_needs, id: @contact.id
  end

  def edit
    @users = User.all
  end

  def update
    if @need.update(need_params)
      redirect_to need_path(@need), notice: 'Need was successfully updated.'
    else
      @users = User.all
      render :edit
    end
  end

  private

  def set_need
    @need = Need.find(params[:id])
    @contact = @need.contact
  end

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def need_params
    params.require(:need).permit(:name, :due_by, :user_id, :category)
  end

  def needs_params
    params.require(:needs).permit!
  end

end
