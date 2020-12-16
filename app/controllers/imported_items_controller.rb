# frozen_string_literal: true

class ImportedItemsController < ApplicationController
  def index
    @params = params.permit(:page, :order, :order_dir)
    @imported_items = policy_scope(ImportedItem)
    @imported_items = @imported_items.filter_and_sort({}, @params.slice(:order, :order_dir))
    @imported_items = @imported_items.page(@params[:page])
    Rails.logger.unknown("User viewed imported contacts table: #{@imported_items.map(&:id)}")
  end

  def new
    Rails.logger.unknown('User requested to see import contacts page')
  end

  def create
    authorize ImportedItem
    @params = params.permit(:file, :imported_item_name)
    if @params[:file].blank?
      flash[:error] = 'File can not be blank'
      return render :new
    end

    ImportedItem.transaction do
      imported_item = ImportedItem.create! name: @params[:imported_item_name], uploaded_by_user_id: current_user.id
      unique_contacts, not_unique_contacts = imported_item.import(@params.slice(:file))
      imported_item.imported = unique_contacts.size
      imported_item.failed = not_unique_contacts.size
      Rails.logger.unknown("User imported new contacts: Successful(#{unique_contacts.size}) / Rejected (#{not_unique_contacts.size})")
      redirect_to imported_items_path(order: 'created_at', order_dir: 'DESC'), notice: import_msg(unique_contacts, not_unique_contacts)
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = e.message
      render :new
    end
  end

  private

  def import_msg(unique_contacts, not_unique_contacts)
    msg = if unique_contacts.empty?
            'Not Created Imported Item'
          else
            'Created Imported Item'
          end
    msg += '<br>Following records are not unique and not imported <br>(Test & Trace ID - NHS number - Forename - Surname):<br>' unless not_unique_contacts.empty?
    not_unique_contacts.each do |contact|
      msg += "#{contact[0]} - #{contact[1]} - #{contact[3]} - #{contact[4]}<br>"
    end
    msg
  end
end
