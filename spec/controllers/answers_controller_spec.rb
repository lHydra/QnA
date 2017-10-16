require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    context 'when user create answer' do
      before do
        sign_in(user)
      end

      context 'with valid attributes' do
        it 'saves the new answer in the db' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
        end

        it 'redirects to the question show view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question}
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'doesn`t saves the new answer in the db' do
          expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
        end
      end
    end

    context 'when guest create answer' do
      it 'doesn`t saves the new answer in the db' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end

      it 'redirects to login page' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question}
        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe 'PUT #update' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, question: question) }

    context 'Author update answer' do
      before do
        sign_in(user)
      end

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          put :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer)).to eq(answer)
        end

        it 'assigns the requested question to @question' do
          put :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:question)).to eq(question)
        end

        it 'updates answer attributes' do
          put :update, params: { id: answer, question_id: question, answer: { body: 'Updated body' } }, format: :js
          answer.reload

          expect(answer.body).to eq('Updated body')
        end

        it 'render update template' do
          put :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'doesn`t update the answer' do
          put :update, params: { id: answer, question_id: question, answer: {body: nil } }, format: :js
          answer.reload

          expect(answer.body).to eq('MyString')
        end
      end
    end

    context 'Guest update the answer' do
      it 'dosn`t update the answer' do
        put :update, params: { id: answer, question_id: question, answer: { body: 'Updated body' } }
        answer.reload

        expect(answer.body).to eq('MyString')
      end

      it 'redirects to login page' do
        put :update, params: { id: answer, question_id: question, answer: { body: 'Updated body' } }
        answer.reload

        expect(response).to redirect_to user_session_path
      end
    end
  end
end
