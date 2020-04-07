class GroceriesAndCookedMealsNeed < Need
  jsonb_accessor :data,
    dietary_requirements: :string,
    has_oven_or_hob: :boolean
end
