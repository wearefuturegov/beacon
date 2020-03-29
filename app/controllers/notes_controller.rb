class NotesController < ApplicationController
  def create
    @contact = Contact.find(params[:contact_id])
    @note = @contact.notes.create(note_params)
    redirect_to contact_path(@contact)
  end

  private
  def note_params
    params.require(:note).permit(:body)
  end

end
