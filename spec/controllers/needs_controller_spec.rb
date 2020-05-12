# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeedsController, type: :controller do
  before :each do
    controller.class.skip_before_action :require_user!, raise: false
    controller.instance_variable_set(:@current_user, {})
    allow_any_instance_of(controller.class).to receive(:authorize).and_return(nil)
  end

  let(:need) do
    need = class_double('Need').as_stubbed_const
    allow(need).to receive(:filter_and_sort).and_return(need)
    allow(need).to receive(:page).and_return(need)
    allow(need).to receive(:started).and_return(need)
    allow(controller).to receive(:policy_scope).with(Need).and_return(need)
    need
  end

  let(:deleted_need) do
    need = class_double('Need').as_stubbed_const
    allow(need).to receive(:filter_and_sort).and_return(need)
    allow(need).to receive(:page).and_return(need)
    allow(need).to receive(:deleted).and_return(need)
    allow(controller).to receive(:policy_scope).with(Need).and_return(need)
    need
  end

  let(:deleted_note) do
    note = class_double('Note').as_stubbed_const
    allow(note).to receive(:filter_and_sort).and_return(note)
    allow(note).to receive(:filter_need_not_destroyed).and_return(note)
    allow(note).to receive(:page).and_return(note)
    allow(note).to receive(:deleted).and_return(note)
    allow(controller).to receive(:policy_scope).with(Note).and_return(note)
    note
  end

  describe 'GET #index' do

    before :each do 
      # roles
      roles = [Role.new(id: 1, name: 'mdt')]
      role_class = class_double(Role).as_stubbed_const
      allow(role_class).to receive(:all).and_return(role_class)
      allow(role_class).to receive(:order).and_return(roles)
    end

    it 'filters on page number passed in params' do
      expect(need).to receive(:page).with('5').and_return(need)
      get :index, params: { page: 5 }
      expect(response).to be_successful
    end

    it 'passes filterable fields to model' do
      expect(need).to receive(:filter_and_sort)
        .with(hash_including(category: 'category_test',
                             assigned_to: 'user-1',
                             status: 'test_status',
                             is_urgent: 'false'), any_args).and_return(need)
      get :index, params: { category: 'category_test', assigned_to: 'user-1', status: 'test_status', is_urgent: 'false' }
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

    it 'populates assignable users options' do
      # users
      users = [User.new(id: 1, first_name: 'User', last_name: 'Test', email: 'user1@test.com')]
      user_class = class_double(User).as_stubbed_const
      allow(user_class).to receive(:all).and_return(user_class)
      allow(user_class).to receive(:order).and_return(users)

      # populates the users list with active users only
      options = subject.construct_assigned_to_options

      expect(user_class).not_to receive(:with_deleted)
      expect(options).to eq("Teams" => [["mdt", "role-1"]],
      +"Users" => [["User Test", "user-1"]])
    end

    it 'populates filterable users options' do
      # users
      users = [User.new(id: 1, first_name: 'User', last_name: 'Test', email: 'user1@test.com', deleted_at: DateTime.now)]
      user_class = class_double(User).as_stubbed_const
      allow(user_class).to receive(:all).and_return(user_class)
      allow(user_class).to receive(:with_deleted).and_return(user_class)
      allow(user_class).to receive(:order).and_return(users)

      # populates the users list including deleted users
      options = subject.construct_assigned_to_options true

      expect(options).to eq("Teams" => [["mdt", "role-1"]],
      +"Users" => [["User Test [X]", "user-1"]])
    end

  end

  describe 'GET #deleted_needs' do
    it 'filters deleted needs on page number passed in params' do
      expect(deleted_need).to receive(:page).with('1').and_return(deleted_need)
      get :deleted_needs, params: { page: 1 }
      expect(response).to be_successful
    end
  end

  describe 'GET #deleted_notes' do
    it 'filters deleted notes on page number passed in params' do
      expect(deleted_note).to receive(:page).with('1').and_return(deleted_note)
      get :deleted_notes, params: { page: 1 }
      expect(response).to be_successful
    end
  end
end
