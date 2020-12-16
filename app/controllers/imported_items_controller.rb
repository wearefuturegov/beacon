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
      imported_item = ImportedItem.create! name: @params[:imported_item_name], user_id: current_user.id
      unique_contacts, not_unique_contacts = imported_item.import(@params.slice(:file))
      imported_item.imported = unique_contacts.size
      imported_item.rejected = not_unique_contacts.size
      imported_item.save
      Rails.logger.unknown("User imported new contacts: Import Record ID #{imported_item.id}, Successful(#{unique_contacts.size}) / Rejected (#{not_unique_contacts.size})")
      redirect_to imported_items_path(order: 'created_at', order_dir: 'DESC'), notice: import_msg(unique_contacts)
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = e.message
      render :new
    end
  end

  private

  def import_msg(unique_contacts)
    unique_contacts.empty? ? 'Not Created Imported Item' : 'Created Imported Item'
  end
end
