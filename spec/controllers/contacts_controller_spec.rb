# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ContactsController do
  let(:user) { double User, email: 'test@emailaddress.com' }

  before(:each) do

    controller.instance_variable_set(:@current_user, user)
  end

  let(:contact) do
    contact = class_double('Contact').as_stubbed_const
    allow(contact).to receive(:all).and_return(contact)
    allow(contact).to receive(:page).and_return(contact)
    contact
  end

  describe 'GET #index' do
    it 'receives contact index with pagination' do
      expect(contact).to receive(:page).with('5').and_return(contact)
      get :index, params: { page: 5 }
      expect(response).to be_successful
    end
  end

  describe 'contact resource' do
    before(:each) do
      @contact_instance = double('Contact')
      allow(@contact_instance).to receive(:id).and_return 1
      @contact_model = class_double('Contact').as_stubbed_const
      allow(@contact_model).to receive(:find).and_return(@contact_instance)
      @user_instance = class_double('User').as_stubbed_const
      allow(@user_instance).to receive(:all).and_return([@user_instance, @user_instance, @user_instance])
    end

    it 'GET #show_needs' do
      get :show_needs, params: { id: 1 }
      expect(assigns(:need)).to be_a_new(Need)
      expect(assigns(:users).size).to eq(3)
      expect(response).to be_successful
    end
  end
end
