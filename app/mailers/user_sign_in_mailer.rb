class UserSignInMailer < ApplicationMailer
  default :from => 'noreply@https://i-have-i-need.herokuapp.com'

  def send_invite_email(user)
    mail(:to => user.email, :subject => "You've have been invited")
  end
end
