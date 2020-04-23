# frozen_string_literal: true

class NotesController < ApplicationController
  def create
    @need = Need.find(params[:need_id])
    authorize @need, :update?
    params = note_params
    params.merge!(body: 'No details captured') if note_params[:body].blank?
    @need.notes.create!(params.merge(user: current_user))

    redirect_to need_path(@need)
  end

  private

  def note_params
    params.require(:note).permit(:body, :category)
  end
end
