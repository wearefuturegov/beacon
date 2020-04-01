class UserSignInMailer < ApplicationMailer
  default :from => YAML.load_file("#{Rails.root.to_s}/config/councils.yml")[ENV['COUNCIL'] || 'demo']['default_from_address']

  def send_invite_email(user)
    mail(:to => user.email, :subject => "You've been invited")
  end
end
