# frozen_string_literal: true

class ImportedItemsController < ApplicationController
  def index
    @imported_item = ImportedItem.new
    @created_item = ImportedItem.where(id: params[:created_id]).first
    @params = params.permit(:page, :order, :order_dir)
    @imported_items = policy_scope(ImportedItem)
    @imported_items = @imported_items.filter_and_sort({}, @params.slice(:order, :order_dir))
    @imported_items = @imported_items.page(@params[:page])
    Rails.logger.unknown("User viewed imported contacts table: #{@imported_items.map(&:id)}")
  end

  def create
    authorize ImportedItem
    @params = params.permit(:authenticity_token, :imported_item => [:file])
    @imported_item = ImportedItem.new(@params[:imported_item])
    @imported_item.user = current_user

    if @imported_item.valid?
      begin
        @imported_item.import
        Rails.logger.unknown("User imported new contacts: Import Record ID #{@imported_item.id}, Successful(#{@imported_item.imported}) / Rejected (#{@imported_item.rejected})")
        redirect_to imported_items_path(order: 'created_at', order_dir: 'DESC', created_id: @imported_item.id), notice: import_msg(@imported_item)
      rescue ActiveRecord::Rollback
        load_imported_items
        render :index
      end
    else
      load_imported_items
      render :index
    end
  end

  private

  def import_msg(imported_item)
    imported_item.imported > 0 ? 'Created Imported Item' : 'Did not create Imported Item'
  end

  def load_imported_items
    @imported_items = policy_scope(ImportedItem)
    @imported_items = @imported_items.filter_and_sort({}, @params.slice(:order, :order_dir))
    @imported_items = @imported_items.page(@params[:page])
  end
end
