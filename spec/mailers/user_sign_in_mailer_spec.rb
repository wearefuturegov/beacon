require "rails_helper"

RSpec.describe UserSignInMailer, type: :mailer do
  before(:each) do
    routes.draw do
      # mock get 'root_url'
      get '/' => 'test#index'
    end
  
    describe 'send invite email' do
      let(:user) { double User, email: 'test@emailaddress.com' }
      let(:mail) { described_class.send_invite_email(user).deliver }

      it 'renders the subject' do
        expect(mail.subject).to eq("You've been invited")
      end

      it 'sends the email to the user' do
        expect(mail.to).to eq(["test@emailaddress.com"])
      end

      it 'is sent from the applications noreply address' do
        expect(mail.from).to eq(["help@beacon.support"])
      end
    end
  end
end