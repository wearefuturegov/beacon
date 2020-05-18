# frozen_string_literal: true

# Model describing all needs for a contact
class ContactNeeds
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :needs_list
  attr_accessor :other_need
end
