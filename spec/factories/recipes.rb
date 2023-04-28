FactoryBot.define do
    factory :recipe do
      name { 'Apple Cake' }
      description { 'This is cake with apple.' }
      preparation_time { '1 hour' }
      cooking_time { '1.5 hours' }
      public { true }
      user { association :user }
    end
  end