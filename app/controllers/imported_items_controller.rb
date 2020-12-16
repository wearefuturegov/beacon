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
      imported_item = ImportedItem.create! name: @params[:imported_item_name]
      unique_contacts, not_unique_contacts = imported_item.import(@params.slice(:file))
      Rails.logger.unknown('User imported new contacts')
      raise ActiveRecord::Rollback if unique_contacts.empty?

      redirect_to imported_items_path(order: 'created_at', order_dir: 'DESC'), notice: import_msg(unique_contacts, not_unique_contacts)
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = e.message
      render :new
    rescue ActiveRecord::Rollback
      flash[:error] = 'Please enter at leat one unique contact'
      render :new
      raise ActiveRecord::Rollback
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
