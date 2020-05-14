# frozen_string_literal: true

class MdtController < NeedsTableController
  def index
    @params = params.permit(:assigned_to, :status, :page, :order_dir, :order, :commit, :is_urgent, :created_by_me)
    @needs = get_needs

    @params[:category] = 'mdt review'
    @needs = @needs.uncompleted.filter_and_sort(@params.slice(:category, :assigned_to, :status, :is_urgent), @params.slice(:order, :order_dir))
    @needs = @needs.page(params[:page]) unless request.format == 'csv'
    @assigned_to_options_with_deleted = construct_assigned_to_options(true)

    handle_response_formats
  end

  # override
  def get_filters_path
    mdt_index_path
  end

  # override
  def get_categories
    []
  end
end
