# frozen_string_literal: true

RSpec.describe 'FactoryBot' do
  it 'has valid factories' do
    expect { FactoryBot.lint }.not_to raise_error
  end
end
