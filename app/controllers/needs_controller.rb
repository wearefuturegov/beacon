# frozen_string_literal: true

class NeedsController < ApplicationController
  include ParamsConcern
  before_action :set_need, only: %i[show edit update]
  before_action :set_contact, only: %i[new create]

  helper_method :get_param

  def index
    @params = params.permit(:user_id, :status, :category, :page, :order_dir, :order, :commit, :is_urgent)
    @users = User.all
    @needs = Need.started
    @needs = @needs.filter_and_sort(@params.slice(:category, :user_id, :status, :is_urgent), @params.slice(:order, :order_dir))
    @needs = @needs.page(params[:page]) unless request.format == 'csv'
    respond_to do |format|
      format.html
      format.csv { send_data @needs.to_csv, filename: "needs-#{Date.today}.csv" }
    end
  end

  def show
    @users = User.all
    @need.notes.order(created_at: :desc)
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
end
