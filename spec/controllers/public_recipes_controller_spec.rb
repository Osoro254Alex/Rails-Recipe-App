require 'rails_helper'

RSpec.describe PublicRecipesController, type: :controller do
  describe 'GET #index' do
    let(:user) { User.create(email: 'test@example.com', password: 'password', confirmed_at: Time.current) }

    before do
      ActionMailer::Base.deliveries.clear
      sign_in user

      @recipe1 = Recipe.create(name: 'Recipe 1', public: true, created_at: 1.day.ago, user:)
      @recipe2 = Recipe.create(name: 'Recipe 2', public: true, created_at: 2.days.ago, user:)
      @recipe3 = Recipe.create(name: 'Recipe 3', public: true, created_at: 3.days.ago, user:)

      get :index
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns public recipes to @recipes' do
      expect(assigns(:recipes)).to match_array([@recipe3, @recipe2, @recipe1])
    end

    it 'orders recipes by created_at in descending order' do
      expect(assigns(:recipes)).to eq([@recipe1, @recipe2, @recipe3])
    end
  end
end
