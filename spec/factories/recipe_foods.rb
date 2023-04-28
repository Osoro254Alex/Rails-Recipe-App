FactoryBot.define do
    factory :recipe_food do
      quantity { 10 }
      food { association :food }
      recipe { association :recipe }
    end
  end