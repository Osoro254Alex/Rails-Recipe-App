require 'rails_helper'

RSpec.describe 'Recipes Index Page', type: :feature do
  let!(:user) { User.create(name: 'Alex', email: 'example@example.com', password: 'password', confirmed_at: Time.current) }
  # rubocop:disable Metrics/BlockLength
  context 'when there are no recipes' do
    before do
      ActionMailer::Base.deliveries.clear
      sign_in user
      visit recipes_path
    end

    it 'displays a message saying there are no recipes available' do
      expect(page).to have_content 'No recipe available'
    end

    scenario 'displays All recipes' do
      expect(page).to have_link 'Add Recipe'
    end
  end

  context 'when there are recipes available' do
    before do
      ActionMailer::Base.deliveries.clear
      sign_in user
      @recipes = [
        Recipe.create(name: 'Recipe 1', description: 'Description 1', user:),
        Recipe.create(name: 'Recipe 2', description: 'Description 2', user:),
        Recipe.create(name: 'Recipe 3', description: 'Description 3', user:)
      ]
      visit recipes_path
    end

    it 'displays a list of recipes' do
      @recipes.each do |recipe|
        expect(page).to have_link(recipe.name, href: recipe_path(recipe))
        expect(page).to have_content(recipe.description)
      end
    end

    scenario 'allows user to delete a recipe' do
      click_on 'Delete Recipe', match: :first
    end

    scenario 'user can add a new recipe' do
      click_on 'Add Recipe'
      expect(page).to have_current_path(new_recipe_path)
    end

    scenario 'allows user to add a recipe' do
      click_on 'Add Recipe'
      fill_in 'Name', with: 'Jamal Goda'
      fill_in 'Description', with: 'Khao banorer ola'
      fill_in 'Preparation time', with: '1 hour'
      fill_in 'Cooking time', with: '1.5 hours'
      check 'Public'
      click_on 'Create Recipe'
      expect(page).to have_content 'Jamal Goda'
    end
  end
  # rubocop:enable Metrics/BlockLength
end
