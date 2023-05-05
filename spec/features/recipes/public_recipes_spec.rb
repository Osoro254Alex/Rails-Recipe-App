require 'rails_helper'

RSpec.describe 'Public Recipes Index Page', type: :feature do
  let!(:user) { User.create(name: 'Alex', email: 'example@example.com', password: 'password', confirmed_at: Time.current) }
  let!(:recipes) do
    [
      Recipe.create(name: 'Recipe 1', description: 'This is recipe 1', user:, public: true),
      Recipe.create(name: 'Recipe 2', description: 'This is recipe 2', user:, public: true),
      Recipe.create(name: 'Recipe 3', description: 'This is recipe 3', user:, public: true)
    ]
  end

  before do
    ActionMailer::Base.deliveries.clear
    user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
    user.confirmed_at = Time.current
    user.save
    sign_in user
    visit public_recipes_path
  end

  scenario 'displays a list of public recipes' do
    expect(page).to have_content 'Public Recipes'
  end

  it 'displays a list of public recipes' do
    recipes.each do |recipe|
      expect(page).to have_link(recipe.name, href: recipe_path(recipe))
      expect(page).to have_content("By: #{recipe.user.name}")
      expect(page).to have_content('Total food items:')
      expect(page).to have_content('Total price:')
    end
  end
end
