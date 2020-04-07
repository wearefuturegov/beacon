require 'rails_helper'
require 'spec_helper'

class ExampleFilterable < ApplicationRecord
  include Filterable
end

RSpec.describe ExampleFilterable do
  let(:mock_query) { double(ActiveRecord::Relation) }
  before do
    allow(ExampleFilterable).to receive(:base_query).and_return(mock_query)
    allow(ExampleFilterable).to receive(:column_names).and_return(%w(field_a field_b))
  end

  it "orders by default_sort if no order params are provided" do
    expect(ExampleFilterable).to receive(:default_sort)
    ExampleFilterable.filter_and_sort({}, {})
  end

  it "orders by the provided order params" do
    expect(mock_query).to receive(:order).with("field_a asc")
    ExampleFilterable.filter_and_sort({}, { :order => "field_a", :order_dir => "asc"})
  end

  it "defaults to default_sort if sorted on a column that is not allowed" do
    allow(ExampleFilterable).to receive(:column_names).and_return([])
    expect(ExampleFilterable).to receive(:default_sort)
    ExampleFilterable.filter_and_sort({}, { :order => "field_a", :order_dir => "asc"})
  end

  it "defaults to default_sort if order_dir is not valid" do
    expect(ExampleFilterable).to receive(:default_sort)
    ExampleFilterable.filter_and_sort({}, { :order => "field_a", :order_dir => "NOT_VALID"})
  end

  it "filters on allow fields" do
    allow(ExampleFilterable).to receive(:column_names).and_return(["allowed_field"])
    expect(mock_query).to receive(:filter_by_allowed_field).with("value").and_return(mock_query)
    ExampleFilterable.filter_and_sort({ :allowed_field => "value" }, {})
  end
end