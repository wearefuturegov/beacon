# frozen_string_literal: true

class NeedsController < NeedsTableController
  before_action :set_need, only: %i[show edit update]
  before_action :set_teams_options, only: %i[show edit update]
  before_action :set_contact, only: %i[new create]

  helper_method :get_param

  def index
    @params = params.permit(:assigned_to, :status, :category, :page, :order_dir, :order, :commit, :is_urgent, :created_by_me, :start_on)
    @needs = needs(@params[:start_on])

    @needs = @needs.filter_and_sort(@params.slice(:category, :assigned_to, :status, :is_urgent), @params.slice(:order, :order_dir))
    @needs = @needs.page(params[:page])
    @assigned_to_options_with_deleted = construct_assigned_to_options(true)
  end

  def deleted_items
    @params = params.permit(:page, :order_dir, :order, :type)
    @items = policy_scope(Need).deleted if params[:type].blank? || params[:type] == 'needs'
    @items = policy_scope(Note).deleted.filter_need_not_destroyed if params[:type] == 'notes'
    @items = @items&.filter_and_sort(@params.slice(:category, :deleted_at), @params.slice(:order, :order_dir))

    @items = @items&.page(params[:page])
  end

  def destroy
    if params[:note_only] == 'true'
      delete_note params
    else
      delete_need params
    end
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    @assigned_to_options = construct_assigned_to_options
    @delete_prompt = get_delete_prompt @need
    render :show
  end

  def show
    Rails.logger.log("User viewed need show page for contact ID: #{@contact.id}")
    @need.notes.order(created_at: :desc)
    populate_page_data
  end

  def edit
    Rails.logger.log("User viewed need edit page for contact ID: #{@contact.id}")
    @delete_prompt = get_delete_prompt @need
  end

  def update
    if @need.update(need_params)
      NeedsAssigneeNotifier.notify_new_assignee(@need)
      respond_to do |format|
        format.html { redirect_to need_path(@need), notice: 'Record successfully updated.' }
        format.js
      end
    else
      respond_to do |format|
        format.html do
          populate_page_data
          render :show
        end
        format.js
      end
    end
  rescue ActiveRecord::StaleObjectError
    flash[:alert] = STALE_ERROR_MESSAGE
    populate_page_data
    render :show
  end

  def bulk_action
    for_update = JSON.parse(params[:for_update])
    updated_needs = []
    for_update.each do |obj|
      need = Need.find(obj['need_id'])
      authorize(need)
      to_update = {}
      to_update[:assigned_to] = assigned_to_me(obj['assigned_to']) if obj.key?('assigned_to')
      to_update[:status] = obj['status'] if obj.key?('status')
      to_update[:send_email] = obj['sendEmail'] if obj.key?('sendEmail')
      need.update! to_update
      updated_needs.append(need)
    end

    NeedsAssigneeNotifier.bulk_notify_new_assignee(updated_needs)
    render json: { status: 'ok' }
  end

  def restore_need
    need = policy_scope(Need).deleted.where(id: params[:id])
    if need.exists?
      need_name = need.first.category
      Rails.logger.info("Restored need '#{params[:id]}'")
      need.first.restore(recursive: true)
      redirect_to deleted_items_path(order: 'deleted_at', order_dir: 'DESC'),
                  notice: "Restored '#{need_name}' see <a href='#{need_path(need.first.id)}'>here</a>"
    else
      redirect_to deleted_items_path(order: 'deleted_at', order_dir: 'DESC'), alert: 'Could not restore record.'
    end
  end

  def restore_note
    note = policy_scope(Note).deleted.where(id: params[:id])
    if note.exists?
      note_name = note.first.category
      Rails.logger.info("Restored note '#{params[:id]}'")
      note.first.restore
      redirect_to deleted_items_path(order: 'deleted_at', order_dir: 'DESC'),
                  notice: "Restored '#{note_name}' see <a href='#{need_path(note.first.need_id)}'>here</a>"
    else
      redirect_to deleted_items_path(order: 'deleted_at', order_dir: 'DESC'), alert: 'Could not restore record.'
    end
  end

  def set_teams_options
    @teams_options = construct_teams_options
  end

  private

  def construct_teams_options
    roles = Role.all.order(:name)
    {
      'Teams' => roles.map { |role| [role.name, role.id.to_s] }
    }
  end

  def delete_note(params)
    note = Note.find(params[:id])
    note.destroy

    @need = Need.find(params[:need_id])
    populate_page_data

    redirect_to need_path(@need)
  end

  def delete_need(params)
    need = Need.find(params[:id])
    need_name = need.category

    if need.destroy
      redirect_to contact_path(need.contact_id), notice: "'#{need_name}' was successfully deleted."
    else
      populate_page_data
      render :show
    end
  end

  def populate_page_data
    @assigned_to_options = construct_assigned_to_options
    @delete_prompt = get_delete_prompt @need
  end

  def get_delete_prompt(need)
    "Only Delete this #{need.category} if you created it by mistake. If it is cancelled, blocked or completed, please update the status instead.  Click OK to delete"
  end

  def set_need
    # handle browsing back to a need that has been deleted
    @need = Need.with_deleted.where(id: params[:id]).first
    redirect_to contact_path(@need.contact_id) if @need.deleted_at

    @contact = @need.contact
    authorize(@need)
    authorize(@contact, :show?)
  end

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end
end
