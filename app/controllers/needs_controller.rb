class NeedsController < ApplicationController
  before_action :set_contact

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def new
    @needs = Needs.new
  end

  def create
    needs_params.each do |key,value|
      if value == "true"
        @contact.tasks.build(name: key.humanize, due_by: DateTime.now + 7.days).save
      end
    end
  end

  private
  def needs_params
    params.require(:needs).permit(:groceries_and_cooked_meals, :physical_and_mental_wellbeing ,:financial_support ,
                                  :staying_social ,:prescription_pickups ,:book_drops_and_entertainment,:dog_walking, :other)
  end
end