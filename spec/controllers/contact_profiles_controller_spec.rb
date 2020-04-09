RSpec.describe ContactProfilesController, type: :controller do
  before :each do
    controller.class.skip_before_action :require_user!, raise: false
    controller.instance_variable_set(:@current_user, {})
  end

  describe 'PUT #create' do
    before(:each) do
      @test_contact = double('Contact')
      allow(@test_contact).to receive(:id).and_return 1
      allow(@test_contact).to receive(:update).and_return(@test_contact)

      @contact = class_double('Contact').as_stubbed_const
      allow(@contact).to receive(:find).and_return(@test_contact)
    end

    it 'redirects to the contacts page for the given contact' do
      needs_list = { 1 => { active: false } }
      put :update, params: { id: 1, contact: { id: 1 }, contact_needs: { needs_list: needs_list } }
      expect(response).to redirect_to controller: :contacts, action: :show, id: 1
    end
  end
end
