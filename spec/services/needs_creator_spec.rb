# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeedsCreator do
  before(:each) do
    @need_class = class_double('Need').as_stubbed_const
    @need = double('Need')
    statuses = { to_do: 'to_do' }
    allow(@need_class).to receive(:statuses).and_return statuses
    allow(@need_class).to receive(:find_or_initialize_by).with(anything).and_return @need

    @builder = double(ActiveRecord::Associations::CollectionProxy)
    allow(@builder).to receive_messages(build: @builder, save: @builder)

    @test_contact = double('Contact')
    allow(@test_contact).to receive(:id).and_return 1
    allow(@test_contact).to receive(:name).and_return 'Contact name'
    allow(@test_contact).to receive(:needs).and_return @builder
  end

  def mock_find_and_destroy
    allow(@need_class).to receive(:where).with(hash_including(id: '1')).and_return @need
    allow(@need).to receive(:exists?).and_return true
    allow(@need).to receive(:first).and_return @need
    allow(@need).to receive(:really_destroy!).and_return true
  end

  it 'saves each active need' do
    # three needs, first two active
    needs_list = {
      '1' => { 'active' => 'true', 'name' => 'category1' },
      '2' => { 'active' => 'true', 'name' => 'category2' },
      '3' => { 'active' => 'false', 'name' => 'category3', 'id' => '1' }
    }
    mock_find_and_destroy
    expect(@need).to receive(:update).with(anything).twice
    described_class.create_needs(@test_contact, needs_list, nil)
  end

  it 'sets a default description if none is provided' do
    needs_list = { '1' => { 'active' => 'true', 'name' => 'category' } }

    allow(@need).to receive(:update).with(hash_including(name: 'Contact name needs category')).and_return @need
    described_class.create_needs(@test_contact, needs_list, nil)
  end

  it 'sets the description from the provided description if provided' do
    needs_list = { '1' => { 'active' => 'true', 'name' => 'category', 'description' => 'test description' } }

    allow(@need).to receive(:update).with(hash_including(name: 'test description')).and_return @need
    described_class.create_needs(@test_contact, needs_list, nil)
  end

  it 'destroys if inactive' do
    needs_list = { '1' => { 'active' => 'false', 'name' => 'category', 'id' => '1' } }
    mock_find_and_destroy
    described_class.create_needs(@test_contact, needs_list, 'test other description')
  end

  it 'parses and populates the start on date if one is present' do
    needs_list = { 1 => { 'active' => 'true', 'name' => 'category', 'start_on' => DateTime.new(2000, 1, 1) } }
    expected_date = DateTime.new(2000, 1, 1)

    allow(@need).to receive(:update).with(hash_including(start_on: expected_date)).and_return @need
    described_class.create_needs(@test_contact, needs_list, nil)
  end

  it 'defaults to a start on date of 6 days from now if start on date is invalid' do
    needs_list = { 1 => { 'active' => 'true', 'name' => 'category', 'start_on' => DateTime.now.beginning_of_day} }
    expected_date = DateTime.now.beginning_of_day

    allow(@need).to receive(:update).with(hash_including(start_on: expected_date)).and_return @need
    described_class.create_needs(@test_contact, needs_list, nil)
  end
end
