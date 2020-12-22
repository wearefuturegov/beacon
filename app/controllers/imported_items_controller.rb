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
    @params = params.permit(:authenticity_token, imported_item: [:file])
    @imported_item = ImportedItem.new(@params[:imported_item])
    @imported_item.user = current_user

    if @imported_item.valid?
      begin
        @imported_item.import
        Rails.logger.unknown("User imported new contacts: Import Record ID #{@imported_item.id}, Successful(#{@imported_item.imported}) / Rejected (#{@imported_item.rejected})")
        redirect_to imported_items_path(order: params[:order], order_dir: params[:order_dir], created_id: @imported_item.id), notice: 'Successfully imported file'
      rescue StandardError => e
        logger.error e.message
        logger.error e.backtrace
        redirect_to imported_items_path(order: params[:order], order_dir: params[:order_dir], created_id: @imported_item.id), notice: 'There was a problem uploading this file'
      end
    else
      load_imported_items
      render :index
    end
  end

  private

  def load_imported_items
    @imported_items = policy_scope(ImportedItem)
    @imported_items = @imported_items.filter_and_sort({}, @params.slice(:order, :order_dir))
    @imported_items = @imported_items.page(@params[:page])
  end
end
