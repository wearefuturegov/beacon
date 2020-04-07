# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

class NeedsTestController < NeedsController
  skip_before_action :require_user!
end

RSpec.describe NeedsTestController do
  before(:each) do
    # test route
    routes.draw do
      resources :needs_test, only: %i[index show edit update create new] do
        resources :needs, only: %i[new create]
      end
      get '/contacts/:id/needs', to: 'contacts#show_needs'
    end
    controller.instance_variable_set(:@current_user, {})
  end

  let(:need) do
    need = class_double('Need').as_stubbed_const
    allow(need).to receive(:filter_and_sort).and_return(need)
    allow(need).to receive(:page).and_return(need)
    need
  end

  describe 'GET #index' do
    it 'filters on page number passed in params' do
      expect(need).to receive(:page).with('5').and_return(need)
      get :index, params: { page: 5 }
      expect(response).to be_successful
    end

    it 'passes filterable fields to model' do
      expect(need).to receive(:filter_and_sort)
        .with(hash_including(category: 'category_test',
                             user_id: '1',
                             status: 'test_status',
                             is_urgent: 'false'), any_args).and_return(need)
      get :index, params: { category: 'category_test', user_id: '1', status: 'test_status', is_urgent: 'false' }
      expect(response).to be_successful
    end

    it 'passes sort fields to model' do
      expect(need).to receive(:filter_and_sort)
        .with(any_args, hash_including(order: 'column_name', order_dir: 'asc'))
        .and_return(need)
      get :index, params: { order: 'column_name', order_dir: 'asc' }
      expect(response).to be_successful
    end

    it 'pages when the request is for html' do
      expect(need).to receive(:page)
      get :index, format: :html
      expect(response).to be_successful
    end

    it 'does not page when the request is for a csv' do
      allow(need).to receive(:to_csv)
      expect(need).not_to receive(:page)
      get :index, format: :csv
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    before(:each) do
      @test_contact = double('Contact')
      allow(@test_contact).to receive(:id).and_return 1
      @contact = class_double('Contact').as_stubbed_const
      allow(@contact).to receive(:find).and_return(@test_contact)
    end

    it 'redirects to the contacts needs list for the given contact' do
      needs_list = { 1 => { active: false } }
      post :create, params: { contact_id: 1, needs_list_form: { needs_list: needs_list } }
      expect(response).to redirect_to controller: :contacts, action: :show_needs, id: 1
    end
  end
end
