# frozen_string_literal: true

class ContactCallForm
  include ActiveModel::Model

  attr_accessor :contact
  attr_accessor :needs_list
  attr_accessor :other_need
end
