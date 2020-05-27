# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeedsController, type: :controller do
  before :each do
    controller.class.skip_before_action :require_user!, raise: false
    controller.instance_variable_set(:@current_user, {})
    allow_any_instance_of(controller.class).to receive(:authorize).and_return(nil)

    allow_any_instance_of(AssigningConcern).to receive(:construct_assigned_to_options).and_return([])
    allow_any_instance_of(AssigningConcern).to receive(:construct_teams_options).and_return([])
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

    it 'inherits parents methods' do
      expect(need).to receive(:page)
      expect(need).to receive(:categories).and_return(['a', 'b', 'c'])
      get :index
      expect(subject.can_bulk_action?).to eq(true)
      expect(subject.categories).to eq(['a', 'b', 'c'])
      expect(subject.filters_path).to eq(root_path)
    end
  end

  describe 'GET #deleted_needs' do
    it 'filters deleted needs on page number passed in params' do
      expect(deleted_need).to receive(:page).with('1').and_return(deleted_need)
      get :deleted_items, params: { page: 1, type: 'needs' }
      expect(response).to be_successful
    end
  end

  describe 'GET #deleted_notes' do
    it 'filters deleted notes on page number passed in params' do
      expect(deleted_note).to receive(:page).with('1').and_return(deleted_note)
      get :deleted_items, params: { page: 1, type: 'notes' }
      expect(response).to be_successful
    end
  end
end
