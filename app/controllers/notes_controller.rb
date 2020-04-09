# frozen_string_literal: true

class NotesController < ApplicationController
  def create
    @need = Need.find(params[:need_id])
    @note = @need.notes.create!(note_params.merge(user: current_user))
    redirect_to need_path(@need)
  end

  private

  def note_params
    params.require(:note).permit(:body, :category)
  end
end
