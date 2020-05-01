require 'rails_helper'
require 'spec_helper'

RSpec.describe AssessmentsController do
  let(:user) { User.new }

  before(:each) do
    controller.instance_variable_set(:@current_user, user)
    @test_contact = Contact.new(id: 1)

    @contact = class_double('Contact').as_stubbed_const
    allow(@contact).to receive(:find).and_return(@test_contact)
  end

  describe 'GET #new' do
    it 'creates a need with status complete when logging an assessment' do
      get :new, params: { contact_id: 1, type: 'log' }
      expect(assigns['need'].status).to eq 'complete'
      expect(response).to be_successful
    end

    it 'auto assigns the need to the current user when logging an assessment' do
      get :new, params: { contact_id: 1, type: 'log' }
      expect(assigns['need'].user).to eq user
      expect(response).to be_successful
    end

    it 'defaults the type to log if passed an invalid type' do
      get :new, params: { contact_id: 1, type: 'invalid' }
      expect(assigns['type']).to eq 'log'
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    before(:each) do
      allow_any_instance_of(controller.class).to receive(:authorize).and_return(nil)
      @need = class_double('Need').as_stubbed_const
      @note = class_double('Note').as_stubbed_const

      @test_need = double('Need')
      allow(@need).to receive(:new).and_return(@test_need)
      allow(@test_need).to receive(:save).and_return(true)
      allow(@test_need).to receive(:valid?).and_return(true)
      allow(@test_need).to receive_messages([:status=, :user=])

      @test_note = double('Note')
      allow(@note).to receive(:new).and_return(@test_note)
      allow(@test_note).to receive(:save).and_return(true)
      allow(@test_note).to receive(:valid?).and_return(true)
    end

    it 'redirects to the contacts show page when successful' do
      post :create, params: { contact_id: 1, type: 'log', need: { category: 'phone triage' }, note: { body: 'test' } }
      expect(response).to redirect_to controller: :contacts, action: :show, id: 1
    end

    it 'saves the note when the assessment is being logged' do
      expect(@test_note).to receive(:save).and_return(true)
      post :create, params: { contact_id: 1, type: 'log', need: { category: 'phone triage' }, note: { body: 'test' } }
      expect(response).to redirect_to controller: :contacts, action: :show, id: 1
    end

    it 'tests the need has a start_on date when it is being scheduled' do
      expect(@test_need).to receive(:valid?).and_return(true)
      post :create, params: { contact_id: 1, type: 'schedule', need: { category: 'phone triage' }, note: { body: 'test' } }
      expect(response).to redirect_to controller: :contacts, action: :show, id: 1
    end
  end
end
