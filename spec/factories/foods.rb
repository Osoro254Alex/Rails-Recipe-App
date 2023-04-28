FactoryBot.define do
    factory :food do
      name { 'Apple' }
      price { 5 }
      measurement_unit { 'gm' }
      quantity { 10 }
      user { association :user }
    end
  end