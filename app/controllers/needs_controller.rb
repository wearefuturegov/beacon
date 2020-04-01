class NeedsController < ApplicationController
  before_action :set_need, only: [:show, :edit, :update]
  before_action :set_contact, only: [:new, :create]

  def index
    @users = User.all
    @needs = Need.includes(:contact, :user)
  end

  def show
  end

  def new
    @needs = Needs.new
  end

  def create
    needs_params["needs_list"].each do |key, value|
      if value["active"] == "true"
        @contact.needs.build(category: value["name"].humanize, name: value["description"], due_by: DateTime.now + 7.days).save
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
