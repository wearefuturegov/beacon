class UserSignInMailer < GovukNotifyRails::Mailer
  
  default :from => Rails.configuration.councils[ENV['COUNCIL'] || :demo][:default_from_address]

  def send_invite_email(user, url)
    
    set_template(Rails.configuration.councils[ENV['COUNCIL'] || :demo][:invite_template])
    set_personalisation(
      beacon_url: url
    )
    mail(:to => user.email)
  end
end
