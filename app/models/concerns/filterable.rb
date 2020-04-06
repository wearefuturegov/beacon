module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = base_query
      filtering_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end

    def sorted_by(order_params)
      return default_sort unless order_params[:order].present? && order_params[:order_dir].present?
      return default_sort unless column_names.include?(order_params[:order])
      return default_sort unless %w(asc desc).include?(order_params[:order_dir].downcase)
      order("#{order_params[:order]} #{order_params[:order_dir]}")
      self
    end

    def default_sort
      self
    end

    def base_query
      self.where(nil)
    end
  end
end