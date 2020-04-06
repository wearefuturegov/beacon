class NeedsController < ApplicationController
  include ParamsConcern
  before_action :set_need, only: [:show, :edit, :update]
  before_action :set_contact, only: [:new, :create]

  helper_method :get_param

  def index
    @params = params.permit(:user_id, :status, :category, :page, :order_dir, :order, :commit, :is_urgent)
    @users = User.all
    @needs = Need.filter(@params.slice(:category, :user_id, :status, :is_urgent))
                 .sorted_by(@params.slice(:order, :order_dir))

    @needs = @needs.page(params[:page]) unless request.format == 'csv'
    respond_to do |format|
      format.html
      format.csv { send_data @needs.to_csv, filename: "needs-#{Date.today}.csv" }
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
        need_category = value["name"].humanize.downcase
        need_description = value["description"]
        if need_description.blank?
          need_description = "#{@contact.name} needs #{need_category}"
        end

        need_is_urgent = value["is_urgent"]

        @contact.needs.build(category: need_category, name: need_description, is_urgent: need_is_urgent, due_by: DateTime.now + 7.days).save
      end
    end

    if needs_params["other_need"]
      @contact.needs.build(category: "other", name: needs_params["other_need"], due_by: DateTime.now + 7.days).save
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
    params.require(:need).permit(:name, :status, :user_id, :category, :is_urgent)
  end

  def needs_params
    params.require(:needs).permit!
  end
end
