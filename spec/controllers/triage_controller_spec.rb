RSpec.describe TriageController, type: :controller do
  before :each do
    expect_any_instance_of(controller.class).to receive(:authorize).and_return(nil)
    controller.class.skip_before_action :require_user!, raise: false
    controller.instance_variable_set(:@current_user, User.new)

    @test_contact = double('Contact')
    allow(@test_contact).to receive(:id).and_return 1
    allow(@test_contact).to receive(:update).and_return(@test_contact)
    allow(@test_contact).to receive(:assign_attributes)
    allow(@test_contact).to receive(:valid?)
    allow(@test_contact).to receive(:errors).and_return([])
    allow(@test_contact).to receive(:save).and_return(true)

    @contact = class_double('Contact').as_stubbed_const
    allow(@contact).to receive(:find).and_return(@test_contact)
  end

  describe 'PUT #update' do
    it 'saves and redirects to the contacts page for the given contact' do
      needs_list = { 1 => { active: false } }
      put :update, params: { id: 1, contact_id: 1, contact: { id: 1 }, contact_needs: { needs_list: needs_list }, discard_draft: 'false', save_for_later: 'false' }
      expect(response).to redirect_to controller: :contacts, action: :show, id: 1
      expect(controller).to set_flash[:notice].to('Contact was successfully updated.')
    end

    it 'saves for later and redirects to the new enquiry' do
      needs_list = { 1 => { active: false } }
      put :update, params: { id: 1, contact_id: 1, contact: { id: 1 }, contact_needs: { needs_list: needs_list }, discard_draft: 'false', save_for_later: 'true' }
      expect(response).to redirect_to new_contact_path
      expect(controller).to set_flash[:notice].to('Triage temporarely saved.')
    end

    it 'discards the draft and redirects to the contact page' do
      needs_list = { 1 => { active: false } }
      put :update, params: { id: 1, contact_id: 1, contact: { id: 1 }, contact_needs: { needs_list: needs_list }, discard_draft: 'true', save_for_later: 'false' }
      expect(response).to redirect_to controller: :contacts, action: :show, id: 1
      expect(controller).to set_flash[:notice].to('Draft triage discarded.')
    end
  end

  describe 'PUT #update triage form fails validation' do
    before(:each) do
      allow(@test_contact).to receive(:save).and_return(false)

      @contact_model = class_double('Contact').as_stubbed_const
      allow(@contact_model).to receive(:find).and_return(@test_contact)
    end

    it 'returns to the edit page' do
      needs_list = { 1 => { active: false } }
      put :update, params: { id: 1, contact_id: 1, contact: { first_name: nil }, contact_needs: { needs_list: needs_list }, discard_draft: 'false', save_for_later: 'false' }
      expect(response).to render_template :edit
    end
  end
end
