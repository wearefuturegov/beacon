# frozen_string_literal: true

class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update]

  def create
    @need = Need.find(params[:need_id])
    authorize @need, :update?
    params = note_params
    params.merge!(body: 'No details captured') if note_params[:body].blank?
    @need.notes.create!(params.merge(user: current_user))
    AuditLog.create(user_id: current_user.id, message: "User created a note on need ID: #{@need.id}")
    redirect_to need_path(@need)
  end

  def update
    authorize @note
    AuditLog.create(user_id: current_user.id, message: "User updated note ID: #{@note.id}")
    @note.update(note_params)
  end

  private

  def note_params
    params.require(:note).permit(:body, :category)
  end

  def set_note
    @note = Note.find params[:id]
  end
end
