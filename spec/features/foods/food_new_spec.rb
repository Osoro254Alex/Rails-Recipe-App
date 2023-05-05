require 'rails_helper'

RSpec.feature 'Foods new', type: :feature do
  let!(:user) { User.create(name: 'Alex', email: 'example@example.com', password: 'password', confirmed_at: Time.current) }

  before do
    ActionMailer::Base.deliveries.clear
    user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
    user.confirmed_at = Time.current
    user.save
    sign_in user
    visit new_food_path
  end

  scenario 'loads add new food page' do
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Measurement unit'
    expect(page).to have_content 'Price'
    expect(page).to have_content 'Quantity'
    expect(page).to have_link 'Cancel'
  end

  scenario 'user can cancel' do
    click_on 'Cancel'
    expect(page).to have_current_path(foods_path)
  end

  scenario 'allows user to add a food' do
    fill_in 'Name', with: 'Ibrahim'
    fill_in 'Measurement unit', with: 'Pound'
    fill_in 'Price', with: 10.00
    fill_in 'Quantity', with: 10
    click_on 'Save Food'
    expect(page).to have_content 'Ibrahim'
  end
end
