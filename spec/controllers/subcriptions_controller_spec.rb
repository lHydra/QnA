require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    context 'when user tries subscribe' do
      before do
        sign_in(user)
      end

      it 'should create a subscriber for the question' do
        expect { post :create, params: { subscription: { question_id: question } }, format: :js }.to change(Subscription, :count).by(1)
      end

      it 'loads question to the @question' do
        post :create, params: { subscription: { question_id: question } }, format: :js
        expect(assigns(:question)).to eq(question)
      end
    end

    context 'when guest tries subscribe' do
      it 'should not create a subscriber for the question' do
        expect { post :create, params: { subscription: { question_id: question } }, format: :js }.not_to change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when user tries to unsubscribe' do
      before do
        sign_in(user)
        user.subscribe!(question)
      end

      it 'deletes the subscriber for the question' do
        expect { delete :destroy, params: { id: Subscription.first }, format: :js }.to change(Subscription, :count).by(-1)
      end

      it 'loads the question to @question' do
        delete :destroy, params: { id: Subscription.first }, format: :js
        expect(assigns(:question)).to eq(question)
      end
    end

    context 'when guest tries unsubscribe' do
      before do
        user.subscribe!(question)
      end

      it 'deletes the subscriber for the question' do
        expect { delete :destroy, params: { id: Subscription.first }, format: :js }.not_to change(Subscription, :count)
      end
    end
  end
end
