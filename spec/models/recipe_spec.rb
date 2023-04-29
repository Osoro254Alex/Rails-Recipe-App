require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let!(:user) { User.create(name: 'Alex', email: 'example@example.com', password: 'password', confirmed_at: Time.current) }
  let!(:flour) { Food.create(name: 'Flour', price: 0.50, measurement_unit: 'gram', quantity: 1000, user:) }
  let!(:sugar) { Food.create(name: 'Sugar', price: 0.75, measurement_unit: 'gram', quantity: 1000, user:) }
  let!(:apple) { Food.create(name: 'Apple', price: 5, measurement_unit: 'gram', quantity: 1000, user:) }

  let!(:recipes) do
    [
      Recipe.create(name: 'Recipe 1', description: 'This is recipe 1', user:, public: true, preparation_time: 10, cooking_time: 20),
      Recipe.create(name: 'Recipe 2', description: 'This is recipe 2', user:, public: true, preparation_time: 15, cooking_time: 25),
      Recipe.create(name: 'Recipe 3', description: 'This is recipe 3', user:, public: true, preparation_time: 20, cooking_time: 30)
    ]
  end

  let!(:recipe_food1) { RecipeFood.create(recipe: recipes.first, food: flour, quantity: 50) }
  let!(:recipe_food2) { RecipeFood.create(recipe: recipes.first, food: sugar, quantity: 10) }
  let!(:recipe_food3) { RecipeFood.create(recipe: recipes.first, food: apple, quantity: 10) }

  describe 'methods' do
    describe '#total_food_items' do
      it 'returns the total number of unique food items in the recipe' do
        expect(recipes.first.all_food_items).to eq(3)
      end
    end

    describe '#total_price' do
      it 'calculates the total price of the recipe' do
        expect(recipes.first.total_price).to eq(82.5)
      end
    end
  end
end
