# frozen_string_literal: true

class MdtController < NeedsTableController
  def index
    @params = params.permit(:assigned_to, :status, :page, :order_dir, :order, :commit, :is_urgent, :created_by_me)
    @needs = if @params[:created_by_me] == 'true'
               @assigned_to_options = {}
               Need.created_by(current_user.id).filter_by_assigned_to('Unassigned')
             else
               @assigned_to_options = construct_assigned_to_options
               policy_scope(Need).started
             end

    @params[:category] = 'mdt review'
    @needs = @needs.uncompleted.filter_and_sort(@params.slice(:category, :assigned_to, :status, :is_urgent), @params.slice(:order, :order_dir))
    @needs = @needs.page(params[:page]) unless request.format == 'csv'
    @assigned_to_options_with_deleted = construct_assigned_to_options(true)
    respond_to do |format|
      format.html
      format.csv do
        authorize(Need, :export?)
        send_data @needs.to_csv, filename: "needs-#{Date.today}.csv"
      end
    end
  end

end
