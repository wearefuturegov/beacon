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

  it 'get default council name' do
    expect(subject.council_name).to eq('Demo Council')
  end

  it 'get default copyright message' do
    expect(subject.copyright).to eq('© 2020 Demo Council')
  end

  it 'get default privacy_link message' do
    expect(subject.privacy_link).to eq('#')
  end

  it 'get default logo_path message' do
    expect(subject.logo_path).to eq('logo-demo.svg')
  end

  it 'get default current_user message' do
    expect(subject.current_user).to eq(user)
  end
end
