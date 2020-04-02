require 'rails_helper'
require 'spec_helper'

RSpec.describe NeedsController do

  before(:each) do
    controller.instance_variable_set(:@current_user, {})
  end

  let(:need) do
    need = class_double("Need").as_stubbed_const
    allow(need).to receive_messages(includes: need, page: need, order: need)
    need
  end

  describe "GET #index" do
    it "orders by created_at in descending order by default" do
      expect(need).to receive(:order).with(:created_at => :desc).and_return(need)
      get :index
      expect(response).to be_successful
    end

    it "filters on page number passed in params" do
      expect(need).to receive(:page).with("5").and_return(need)
      get :index, params: { page: 5 }
      expect(response).to be_successful
    end

    it "orders on the column passed in params, with the specified order" do
      allow(need).to receive(:column_names).and_return(["column"])
      expect(need).to receive(:order).with("column asc").and_return(need)
      get :index, params: { order: "column", order_dir: "asc" }
      expect(response).to be_successful
    end

    it "defaults to filtering on created by if sorted on a column that is not allowed" do
      allow(need).to receive(:column_names).and_return(["real_column"])
      expect(need).to receive(:order).with("created_at asc").and_return(need)
      get :index, params: { order: "fake_column", order_dir: "asc" }
      expect(response).to be_successful
    end

    it "filters on category" do
      expect(need).to receive(:filter_by_category).with("category_test").and_return(need)
      get :index, params: { category: "category_test" }
      expect(response).to be_successful
    end

    it "filters on user_id" do
      expect(need).to receive(:filter_by_user_id).with("1").and_return(need)
      get :index, params: { user_id: 1 }
      expect(response).to be_successful
    end

    it "filters on status" do
      expect(need).to receive(:filter_by_status).with("status").and_return(need)
      get :index, params: { status: "status" }
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
