# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

# class ApplicationTestController < ApplicationController
#  skip_before_action :require_user!
# end

RSpec.describe ApplicationController do
  let(:user) { double User, email: 'test@emailaddress.com' }
  before(:each) do
    controller.instance_variable_set(:@current_user, user)
  end

  it 'gets default council name' do
    expect(subject.council_name).to eq('Demo Council')
  end

  it 'gets default copyright message' do
    expect(subject.copyright).to eq('© 2020 Demo Council')
  end

  it 'gets default privacy_link message' do
    expect(subject.privacy_link).to eq('#')
  end

  it 'gets default logo_path message' do
    expect(subject.logo_path).to eq('logo-demo.svg')
  end

  it 'gets default current_user message' do
    expect(subject.current_user).to eq(user)
  end

  it 'gets default support_email message' do
    expect(subject.support_email).not_to eq(nil)
    expect(subject.support_email =~ URI::MailTo::EMAIL_REGEXP).to be_truthy
  end
end