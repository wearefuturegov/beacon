class NeedsController < ApplicationController
  before_action :set_contact

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def new
    @needs = Needs.new
  end

  def create
    needs_params["needs_list"].each do |key, value|
      if value["active"] == "true"
        @contact.tasks.build(category: value["name"].humanize, name: value["description"], due_by: DateTime.now + 7.days).save
      end
    end

    if needs_params["other_need"]
      @contact.tasks.build(category: "Other", name: needs_params["other_need"], due_by: DateTime.now + 7.days).save
    end

    redirect_to controller: :contacts, action: :show_tasks, id: @contact.id
  end

  private
  def needs_params
    params.require(:needs).permit!
  end
end