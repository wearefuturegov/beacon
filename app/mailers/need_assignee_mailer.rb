class NeedAssigneeMailer < GovukNotifyRails::Mailer
  default from: Rails.configuration.councils[ENV['COUNCIL'] || :demo][:default_from_address]

  def send_user_assigned_need_email(email, url)
    set_template(Rails.configuration.councils[ENV['COUNCIL'] || :demo][:need_assigned_user_template])
    set_personalisation(
        beacon_url: url
    )
    mail(to: email)
  end

  def send_role_assigned_need_email(email, role, url)
    set_template(Rails.configuration.councils[ENV['COUNCIL'] || :demo][:need_assigned_role_template])
    set_personalisation(
      beacon_url: url,
      role: role
    )
    mail(to: email)
  end
end