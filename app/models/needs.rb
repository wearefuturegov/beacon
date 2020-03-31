class Needs
  include ActiveModel::Model

  attr_accessor :groceries_and_cooked_meals
  attr_accessor :physical_and_mental_wellbeing
  attr_accessor :financial_support
  attr_accessor :staying_social
  attr_accessor :prescription_pickups
  attr_accessor :book_drops_and_entertainment
  attr_accessor :dog_walking
  attr_accessor :other
end