class ContactChannel < ApplicationCable::Channel
  def subscribed
    stream_for contact(params[:id])
  end

  def viewing(data)
    return unless data

    ContactChannel.broadcast_to(contact(data['contact_id']), { userEmail: data['user_email'], type: 'VIEW' })
  end

  def unsubscribed
    stop_all_streams
  end

  def contact(user_id)
    Contact.find(user_id)
  end
end
