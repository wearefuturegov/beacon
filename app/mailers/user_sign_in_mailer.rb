class UserSignInMailer < ApplicationMailer
  default :from => 'help@beacon.support'
  
  def send_invite_email(user)
    mail(:to => user.email, :subject => "You've been invited")
  end
end
