# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before :each do
    controller.class.skip_before_action :require_user!, raise: false
    controller.instance_variable_set(:@current_user, {})
    allow_any_instance_of(controller.class).to receive(:authorize).and_return(nil)
  end

  let(:user_class) do
    user_class = class_double('User').as_stubbed_const
    allow(user_class).to receive(:all).and_return(user_class)
    allow(user_class).to receive(:with_deleted).and_return(user_class)
    allow(user_class).to receive(:name_order).and_return(user_class)
    allow(user_class).to receive(:page).and_return(user_class)
    user_class
  end

  describe 'GET #index' do
    it 'filters on page number passed in params' do
      expect(user_class).to receive(:page).with('1').and_return(user_class)
      get :index, params: { page: 1 }
      expect(response).to be_successful
    end

    it 'searches for a user' do
      expect(user_class).to receive(:search).with('bob').and_return(user_class)
      get :index, params: { search: 'bob'}
      expect(response).to be_successful
    end
  end


  describe 'DELETE #destroy' do
    it 'destroys a user' do
        @test_user = User.new(id: 1, roles: [])
        allow(user_class).to receive(:find).and_return(@test_user)
        delete :destroy, params: { id: 1 }
        expect(response).to redirect_to controller: :users, action: :index
        expect(controller).to set_flash[:notice].to('User was successfully deleted.')
    end
  end
end
