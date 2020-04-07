# frozen_string_literal: true

module ParamsConcern
  extend ActiveSupport::Concern

  included do
    helper_method :get_param_capitalized
  end

  def get_param_capitalized(param_name)
    params[param_name]&.capitalize
  end
end
