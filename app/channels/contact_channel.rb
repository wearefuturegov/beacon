class ContactChannel < ApplicationCable::Channel
  def subscribed
    contact = Contact.find(params[:id])
    stream_for contact
  end

  def viewing(contact_id)
    ActionCable.server.broadcast("contact_id_#{contact_id['contact_id']}", current_user.email)
  end

  def unsubscribed
    stop_all_streams
  end
end
