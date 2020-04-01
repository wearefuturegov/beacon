class MyNeedsController < ApplicationController
  include ParamsConcern
  def index
    @needs = current_user.needs.includes(:contact, :user).page(params[:page])
    @users = [current_user]
  end
end
