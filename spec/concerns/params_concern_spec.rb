# frozen_string_literal: true

require 'rails_helper'

# Concerns cannot be easily tested directly, using test controllers is the simplest way
class TestController < ApplicationController
  skip_before_action :require_user!
  include ParamsConcern
  def index
    render plain: 'OK'
  end
end

RSpec.describe TestController, type: :controller do
  before(:each) do
    routes.draw do
      get '/' => 'test#index'
    end
  end

  after do
    Rails.application.reload_routes!
  end

  it '#get_param_capitalized' do
    get :index, params: { foo: 'value' }
    expect(subject.get_param_capitalized('foo')).to eq('Value')
  end
end
