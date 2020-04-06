require 'rails_helper'
require 'spec_helper'

class NeedsTestController < NeedsController
  skip_before_action :require_user!
end


RSpec.describe NeedsTestController do

  before(:each) do
    # test route
    routes.draw do
      resources :needs_test, only: [:index, :show, :edit, :update, :create, :new] do
        resources :needs, only: [:new, :create]
      end
      get '/contacts/:id/needs', to: 'contacts#show_needs'
    end
    controller.instance_variable_set(:@current_user, {})
  end

  let(:need) do
    need = class_double("Need").as_stubbed_const
    allow(need).to receive(:filter_and_sort).and_return(need)
    allow(need).to receive(:page).and_return(need)
    need
  end

  describe "GET #index" do
    it "filters on page number passed in params" do
      expect(need).to receive(:page).with("5").and_return(need)
      get :index, params: { page: 5 }
      expect(response).to be_successful
    end

    it "passes filterable fields to model" do
      expect(need).to receive(:filter_and_sort)
                          .with(hash_including(:category => "category_test",
                                               :user_id => "1",
                                               :status => "test_status",
                                               :is_urgent => "false"), any_args
                          ).and_return(need)
      get :index, params: { category: "category_test", user_id: "1", status: "test_status", is_urgent: "false" }
      expect(response).to be_successful
    end

    it "passes sort fields to model" do
      expect(need).to receive(:filter_and_sort)
                          .with(any_args, hash_including(:order => "column_name", :order_dir => "asc"))
                          .and_return(need)
      get :index, params: { order: "column_name", order_dir: "asc" }
      expect(response).to be_successful
    end

    it "pages when the request is for html" do
      expect(need).to receive(:page)
      get :index, format: :html
      expect(response).to be_successful
    end

    it "does not page when the request is for a csv" do
      allow(need).to receive(:to_csv)
      expect(need).not_to receive(:page)
      get :index, format: :csv
      expect(response).to be_successful
    end
  end

  describe "POST #create" do

    before(:each) do
      controller.instance_variable_set(:@current_user, {})

      @builder = double(ActiveRecord::Associations::CollectionProxy)
      allow(@builder).to receive_messages(build: @builder, save: @builder)

      @test_contact = double("Contact")
      allow(@test_contact).to receive(:id).and_return 1
      allow(@test_contact).to receive(:name).and_return "Contact name"
      allow(@test_contact).to receive(:needs).and_return @builder

      @contact = class_double("Contact").as_stubbed_const
      allow(@contact).to receive(:find).and_return(@test_contact)
    end

    it "saves each active need" do
      # three needs, first two active
      needs_list = [1,2,3].map{|i| [i, { active: [1,2].include?(i), name: "category" }]}.to_h

      expect(@builder).to receive(:save).twice
      post :create, params: { contact_id: 1, :needs => {:needs_list => needs_list}}
      expect(response).to redirect_to controller: :contacts, action: :show_needs, id: 1
    end

    it "sets a default description if none is provided" do
      needs_list = {1 => { active: true, name: "category" }}

      expect(@builder).to receive(:build).with(hash_including(:name => "Contact name needs category")).once
      post :create, params: { contact_id: 1, :needs => {:needs_list => needs_list}}
      expect(response).to redirect_to controller: :contacts, action: :show_needs, id: 1
    end

    it "sets the description from the provided description if provided" do
      needs_list = {1 => { active: true, name: "category", description: "test description" }}

      expect(@builder).to receive(:build).with(hash_including(:name => "test description")).once
      post :create, params: { contact_id: 1, :needs => {:needs_list => needs_list}}
      expect(response).to redirect_to controller: :contacts, action: :show_needs, id: 1
    end

    it "adds an 'other' need if a description is provided" do
      needs_list = { 1 => { active: false }}

      expect(@builder).to receive(:build).with(hash_including(:name => "test other description")).once
      post :create, params: { contact_id: 1, :needs => {:needs_list => needs_list, :other_need => "test other description"}}
      expect(response).to redirect_to controller: :contacts, action: :show_needs, id: 1
    end
  end
end
