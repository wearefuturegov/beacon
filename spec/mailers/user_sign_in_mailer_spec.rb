require "rails_helper"

RSpec.describe UserSignInMailer, type: :mailer do

  before do
    Rails.application.reload_routes!
  end

  describe 'send invite email' do

    let(:template) { '31d2b530-8db4-44ce-9bfa-34b01519335f' }
    let(:user) { double User, email: 'test@emailaddress.com' }
    let(:mail) { described_class.send_invite_email(user, 'http://localhost:3000/') }
    let(:personalisation) { { beacon_url: 'http://localhost:3000/' } }

    it 'sets the recipient' do
      expect(mail.to).to eq(['test@emailaddress.com'])
    end
    
    it 'sets the subject' do
      expect(mail.body).to match("This is a GOV.UK Notify email with template #{template}")
    end

    it 'sets the template' do
      expect(mail.govuk_notify_template).to eq(template)
    end

    it 'does not set the reference' do
      expect(mail.govuk_notify_reference).to be_nil
    end

    it 'sets the personalisation' do
      expect(mail.govuk_notify_personalisation.keys).to eq([:beacon_url])
    end
  end
end