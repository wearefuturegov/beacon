class UserSignInMailer < GovukNotifyRails::Mailer
  
  default :from => Rails.configuration.councils[ENV['COUNCIL'] || :demo][:default_from_address]

  def send_invite_email(user)
    set_template('31d2b530-8db4-44ce-9bfa-34b01519335f')
    set_personalisation(
      beacon_url: root_url
    )
    mail(:to => user.email)
  end
end
