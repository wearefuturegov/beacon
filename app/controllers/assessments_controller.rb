# frozen_string_literal: true

class AssessmentsController < ApplicationController
  include ParamsConcern

  before_action :set_contact

  def new
    @assessments = policy_scope(@contact.needs, policy_scope_class: ContactNeedsPolicy::Scope)
                   .assessments
                   .where(completed_on: nil)
                   .started
  end

  def schedule
    @users = User.all
  end

  def log
    @users = User.all
  end

  private

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end
end
