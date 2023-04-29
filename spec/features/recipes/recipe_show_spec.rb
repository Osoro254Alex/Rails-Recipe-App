require 'rails_helper'

RSpec.describe 'Recipes show Page', type: :feature do
  let!(:user) { User.create(name: 'Alex', email: 'example@example.com', password: 'password', confirmed_at: Time.current) }
  let!(:recipes) do
    [
      Recipe.create(name: 'Recipe 1', description: 'This is recipe 1', user:, public: true, preparation_time: 10, cooking_time: 20),
      Recipe.create(name: 'Recipe 2', description: 'This is recipe 2', user:, public: true, preparation_time: 15, cooking_time: 25),
      Recipe.create(name: 'Recipe 3', description: 'This is recipe 3', user:, public: true, preparation_time: 20, cooking_time: 30)
    ]
  end
  let!(:food) { Food.create(name: 'Banana', measurement_unit: 'grams', price: 12, quantity: 10, user:) }

  before do
    ActionMailer::Base.deliveries.clear
    user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
    user.confirmed_at = Time.current
    user.save
    sign_in user
    visit recipe_path(recipes.first)
  end

  scenario 'load recipe page' do
    expect(page).to have_content "Preparation Time: #{recipes.first.preparation_time}"
    expect(page).to have_content "Cooking Time: #{recipes.first.cooking_time}"
    expect(page).to have_content 'Steps:'
    expect(page).to have_content recipes.first.description
    expect(page).to have_content 'Change Status:'
    expect(page).to have_link 'Generate shopping list'
    expect(page).to have_link 'Add Ingredient'
  end

  scenario 'user can generate shopping list' do
    click_on 'Generate shopping list'
    expect(page).to have_current_path(general_shopping_list_index_path)
  end

  scenario 'user can add a new ingredient' do
    click_on 'Add Ingredient'
    expect(page).to have_current_path(new_recipe_recipe_food_path(recipes.first.id))
  end

  scenario 'allows user to add a food' do
    click_on 'Add Ingredient'
    select 'Banana', from: 'recipe_food[food_id]'
    click_on 'Add Ingredient'
    expect(page).to have_content 'Ingredient added successfully!'
  end
end
