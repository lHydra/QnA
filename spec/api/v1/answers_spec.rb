require 'rails_helper'

describe 'Answer API' do
  describe 'GET #index' do
    let!(:question) { create(:question) }

    it_behaves_like 'API unauthorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before do
        get api_v1_question_answers_path(question), params: { access_token: access_token.token, format: :json }
      end

      it 'should be success if access token is valid' do
        expect(response).to be_success
      end

      it 'should return list of answers for this question' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at user_id question_id).each do |attr|
        it "includes #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get api_v1_question_answers_path(question), params: options.merge(format: :json)
    end
  end

  describe 'GET #show' do
    let!(:answer) { create(:answer) }

    it_behaves_like 'API unauthorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment_on_answer, commentable: answer) }
      let!(:attachment) { create(:attachment_on_answer, attachmentable: answer) }

      before do
        get api_v1_answer_path(answer), params: { access_token: access_token.token, format: :json }
      end

      it 'should be success' do
        expect(response).to be_success
      end

      %w(body created_at updated_at user_id question_id).each do |attr|
        it "Answer object includes #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      it_behaves_like 'Object with comments'
      it_behaves_like 'Object with attachments'
    end

    def do_request(options = {})
      get api_v1_answer_path(answer), params: options.merge(format: :json)
    end
  end

  describe 'POST #create' do
    let!(:question) { create(:question) }

    it_behaves_like 'API unauthorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'valid params' do
        let(:answer) { create(:answer) }

        before do
          post api_v1_question_answers_path(question), params: { answer: attributes_for(:answer), access_token: access_token.token, format: :json }
        end

        it 'returns status code 201' do
          expect(response.status).to eq(201)
        end

        it 'creates a answer' do
          expect(response.body).to be_json_eql(answer.body.to_json).at_path('body')
        end
      end

      context 'invalid params' do
        before do
          post api_v1_question_answers_path(question), params: { answer: attributes_for(:invalid_answer), access_token: access_token.token, format: :json }
        end

        it 'returns status code 422' do
          expect(response.status).to eq(422)
        end

        it 'returns validation failured messsage' do
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0')
        end
      end
    end
  end

  def do_request(options = {})
    default = { answer: attributes_for(:answer), format: :json }
    post api_v1_question_answers_path(question), params: options.merge(default)
  end
end
