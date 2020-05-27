# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MdtController, type: :controller do
  before :each do
    controller.class.skip_before_action :require_user!, raise: false
    controller.instance_variable_set(:@current_user, {})
    allow_any_instance_of(AssigningConcern).to receive(:construct_assigned_to_options).and_return([])
    allow_any_instance_of(AssigningConcern).to receive(:construct_teams_options).and_return([])
  end

  let(:need) do
    need = class_double('Need').as_stubbed_const
    allow(need).to receive(:filter_and_sort).and_return(need)
    allow(need).to receive(:page).and_return(need)
    allow(need).to receive(:started).and_return(need)
    need
  end

  describe 'GET #index' do
    before :each do
      # roles
      roles = [Role.new(id: 1, name: 'mdt')]
      role_class = class_double(Role).as_stubbed_const
      allow(role_class).to receive(:all).and_return(role_class)
      allow(role_class).to receive(:order).and_return(roles)

      expect(need).to receive(:uncompleted).and_return(need)
    end

    it 'filters on page number passed in params' do
      expect(need).to receive(:page).with('1').and_return(need)
      get :index, params: { page: 1 }
      expect(response).to be_successful
    end

    it 'overrides parents methods' do
      get :index
      expect(subject.can_bulk_action?).to eq(false)
      expect(subject.categories).to eq([])
      expect(subject.filters_path).to eq(mdt_index_path)
    end

    it 'passes filterable fields to model but category is overridden' do
      expect(need).to receive(:filter_and_sort)
        .with(hash_including(category: 'mdt review',
                             assigned_to: 'user-1',
                             status: 'test_status',
                             is_urgent: 'false'), any_args).and_return(need)
      get :index, params: { category: 'to-be-overridden', assigned_to: 'user-1', status: 'test_status', is_urgent: 'false' }
      expect(response).to be_successful
    end

    it 'passes sort fields to model' do
      expect(need).to receive(:filter_and_sort)
        .with(any_args, hash_including(order: 'urgent', order_dir: 'asc'))
        .and_return(need)
      get :index, params: { order: 'urgent', order_dir: 'asc' }
      expect(response).to be_successful
    end
  end
end
