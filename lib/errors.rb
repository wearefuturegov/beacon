module Exceptions
  class NoValidRoleError < StandardError; end

  class NotUniqueRecord < StandardError
    attr_reader :not_unique_records

    def initialize(not_unique_records)
      @not_unique_records = not_unique_records
    end
  end
end
