require 'rails_helper'

RSpec.describe 'Recipes Food New Page', type: :feature do
  let!(:user) { User.create(email: 'example@example.com', password: 'password', confirmed_at: Time.current) }

  before do
    ActionMailer::Base.deliveries.clear
    user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
    user.save
    sign_in user
    @recipe = Recipe.create(name: 'Recipe', description: 'Description', cooking_time: '1 hour', preparation_time: '1 hour', user:)
    @food = Food.create(name: 'Banana', measurement_unit: 'grams', price: 12, quantity: 10, user:)
    visit new_recipe_recipe_food_path(@recipe.id)
  end

  scenario 'load new recipe page' do
    expect(page).to have_content 'Add Ingredient'
    expect(page).to have_content 'Food name'
    expect(page).to have_content 'Quantity'
  end

  scenario 'allows user to add a recipe' do
    select 'Banana', from: 'recipe_food[food_id]'
    expect(page).to have_content 'Banana'
  end
end
