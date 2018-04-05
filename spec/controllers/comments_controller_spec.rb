require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in(user) }

  context 'comment for question' do
    let(:question) { create(:question) }

    describe 'POST#create' do
      it 'loads question' do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
        expect(assigns(:parent)).to eq(question)
      end

      it 'saves new comment to bd' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(Comment, :count).by(1)
      end
    end
  end

  context 'comment for answer' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    describe 'POST#create' do
      it 'loads question' do
        post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js
        expect(assigns(:parent)).to eq(answer)
      end

      it 'saves new comment to bd' do
        expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to change(Comment, :count).by(1)
      end
    end
  end
end
