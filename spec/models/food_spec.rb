require 'rails_helper'

RSpec.describe Food, type: :model do
  let!(:ellon) { User.create(name: 'Ellon', email: 'abc.gmail.com') }
  let!(:flour) { Food.create(name: 'Flour', price: 0.50, measurement_unit: 'gram', quantity: 1000, user: ellon) }

  let!(:apple_cake) do
    Recipe.create(name: 'Apple cake', description: 'This is apple cake recipe', preparation_time: '1 hour',
                  cooking_time: '1.5 hours', public: true, user: ellon)
  end
  let!(:simple_cake) do
    Recipe.create(name: 'Simple cake', description: 'This is simple cake recipe', preparation_time: '1 hour',
                  cooking_time: '1.5 hours', public: true, user: ellon)
  end

  let!(:recipe_food1) { RecipeFood.create(recipe: apple_cake, food: flour, quantity: 50) }
  let!(:recipe_food2) { RecipeFood.create(recipe: simple_cake, food: flour, quantity: 50) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:recipe_foods).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:measurement_unit) }
    it { should validate_presence_of(:quantity) }
  end
end