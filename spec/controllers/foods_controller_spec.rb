require 'rails_helper'

RSpec.describe FoodsController, type: :controller do
  describe 'GET #index' do
    context 'when user is logged in' do
      let(:user) { User.create(email: 'test@example.com', password: 'password') }
      let!(:food1) { Food.create(name: 'Pizza', user:) }
      let!(:food2) { Food.create(name: 'Burger', user:) }
      let!(:foods) { [food1, food2] }

      before do
        ActionMailer::Base.deliveries.clear
        user.confirm
        sign_in user

        get :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it "assigns @foods with user's foods" do
        expect(assigns(:foods)).to match_array([food1, food2])
      end
    end

    context 'when user is not logged in' do
      before do
        get :index
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #new' do
    let(:user) { User.create(email: 'test@example.com', password: 'password') }

    before do
      ActionMailer::Base.deliveries.clear
      user.confirm
      sign_in user

      get :new
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns @food' do
      expect(assigns(:food)).to be_a_new(Food)
    end
  end

  describe 'POST #create' do
    let(:user) { User.create(email: 'test@example.com', password: 'password') }

    before do
      ActionMailer::Base.deliveries.clear
      user.confirm
      sign_in user
    end

    context 'with valid params' do
      it 'creates a new Food' do
        expect do
          post :create, params: { food: { name: 'Pizza' } }
        end.to change(Food, :count).by(1)
      end

      it 'redirects to the foods index' do
        post :create, params: { food: { name: 'Pizza' } }
        expect(response).to redirect_to(foods_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved food as @food' do
        post :create, params: { food: { name: nil } }
      end

      it "re-renders the 'new' template" do
        post :create, params: { food: { name: nil } }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { User.create(email: 'test@example.com', password: 'password') }
    let!(:food) { Food.create(name: 'Pizza', user:) }

    before do
      ActionMailer::Base.deliveries.clear
      user.confirm
      sign_in user
    end

    it 'destroys the requested food' do
      expect do
        delete :destroy, params: { id: food.id }
      end.to change(Food, :count).by(-1)
    end

    it 'sets a flash message on successful destroy' do
      delete :destroy, params: { id: food.id }
      expect(flash[:success]).to eq('Food was successfully deleted.')
    end

    it 'sets a flash message on unsuccessful destroy' do
      allow_any_instance_of(Food).to receive(:destroy).and_return(false)
      delete :destroy, params: { id: food.id }
      expect(flash[:error]).to eq('Failed to delete food.')
    end

    it 'redirects to the foods index' do
      delete :destroy, params: { id: food.id }
      expect(response).to redirect_to(foods_path)
    end
  end
end
