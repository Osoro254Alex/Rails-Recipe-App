require 'rails_helper'

RSpec.feature 'Shopping List', type: :feature do
  let(:user) { User.create(email: 'example@example.com', password: 'password', confirmed_at: Time.current) }

  before do
    ActionMailer::Base.deliveries.clear
    user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
    user.save
    sign_in user
    Food.create(name: 'Food 1', price: 50, quantity: 1, user:)
    Food.create(name: 'Food 2', price: 50, quantity: 1, user:)
    Food.create(name: 'Food 3', price: 50, quantity: 1, user:)
    visit general_shopping_list_index_path
  end

  scenario 'displays a list of foods' do
    # expect(page).to have_content 'Shopping List'
    expect(page).to have_content 'Amount of food items to buy: 3'
    expect(page).to have_content 'Total value of food needed: $150.00'
    expect(page).to have_selector 'table tbody tr', count: 3
  end
end
