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
      imported_item.import(@params.slice(:file))
      Rails.logger.unknown('User imported new contacts')
      redirect_to imported_items_path(order: 'created_at', order_dir: 'DESC'), notice: 'Created Imported Item'
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
    render :new
  end
end
