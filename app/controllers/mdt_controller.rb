# frozen_string_literal: true

class MdtController < NeedsTableController
  def index
    @params = params.permit(:assigned_to, :status, :page, :order_dir, :order, :commit, :is_urgent, :created_by_me)
    @assigned_to_options = construct_assigned_to_options
    @needs = Need.started(@params[:start_on])

    @params[:category] = 'mdt review'
    @needs = @needs.uncompleted.filter_and_sort(@params.slice(:category, :assigned_to, :status, :is_urgent), @params.slice(:order, :order_dir))
    @needs = @needs.page(params[:page]) unless request.format == 'csv'
    @assigned_to_options_with_deleted = construct_assigned_to_options(true)
    Rails.logger.unknown("User viewed MDT table: #{@needs.map(&:id)}")

    handle_response_formats
  end

  # override
  def filters_path
    mdt_index_path
  end

  # override
  def categories
    []
  end

  # override
  def can_bulk_action?
    false
  end
end
