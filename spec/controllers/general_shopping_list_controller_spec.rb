require 'rails_helper'

RSpec.describe GeneralShoppingListController, type: :controller do
  describe 'GET #index' do
    let(:user) { User.create(email: 'user@example.com', password: 'password', confirmed_at: Time.current) }
    let!(:food1) { Food.create(user:, name: 'Food 1', quantity: 2, price: 3.5) }
    let!(:food2) { Food.create(user:, name: 'Food 2', quantity: 1, price: 2.0) }
    let(:recipe) { Recipe.create(user:, name: 'Recipe') }
    let!(:recipe_food) { RecipeFood.create(recipe:, food: food1) }

    before do
      ActionMailer::Base.deliveries.clear
      user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
      user.save
      sign_in user
    end

    context 'when the user has missing foods' do
      before do
        get :index
      end

      it 'assigns the missing foods to @missing_foods' do
        expect(assigns(:missing_foods)).to match_array([food2])
      end

      it 'assigns the shopping list items to @shopping_list_items' do
        expect(assigns(:shopping_list_items)).to eq([{ food: food2, quantity: food2.quantity, price: food2.price * food2.quantity }])
      end

      it 'assigns the total number of items to @total_items' do
        expect(assigns(:total_items)).to eq(1)
      end

      it 'assigns the total price to @total_price' do
        expect(assigns(:total_price)).to eq(2.0)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'when the user has no missing foods' do
      before do
        food2.update(quantity: 0)
        get :index
      end

      it 'assigns 0 to @total_items' do
        expect(assigns(:total_items)).to eq(1)
      end

      it 'assigns 0.0 to @total_price' do
        expect(assigns(:total_price)).to eq(0.0)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end
end
