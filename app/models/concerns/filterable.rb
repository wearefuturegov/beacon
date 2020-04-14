# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    # Filter and sort an ActiveRecord table with the provided params
    # Include on an ApplicationRecord object via:
    # 'include Filterable'
    #
    # Filter and sort on parameters like:
    # 'ObjectName.filter_and_sort(params.slice(:example1), params.slice(:order, :order_dir))'
    #
    # Override #default_sort to modify the default sort order if no/invalid order params are supplied
    # Override #base_query to change the root query for the table, e.g. to include relations
    #
    # @param filtering_params The parameters to filter the table on
    # @param ordering_params The parameters to order the table on
    def filter_and_sort(filtering_params, ordering_params)
      results = base_query
      filtering_params.each do |key, value|
        if value.present?
          results = results.public_send("filter_by_#{key}", value)
        end
      end

      # filter field and direction to known values
      order_field = ordering_params[:order]
      order_direction = ordering_params[:order_dir]
      unless order_field.present? && order_direction.present?
        return default_sort(results)
      end
      return default_sort(results) unless (column_names + dynamic_fields).include?(order_field)
      unless %w[asc desc].include?(order_direction.downcase)
        return default_sort(results)
      end

      # check for overridden order scope
      if respond_to?("order_by_#{order_field}")
        return results.public_send("order_by_#{order_field}", order_direction)
      end

      results.order("#{ordering_params[:order]} #{ordering_params[:order_dir]}")
    end

    # define a default sort order on a query
    def default_sort(results)
      results
    end

    # define a base query for the type
    def base_query
      where(nil)
    end

    # define an empty array for dynamic fields
    def dynamic_fields
      []
    end
  end
end
