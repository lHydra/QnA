require 'rails_helper'

describe 'API question' do
  describe 'GET #index' do
    it_behaves_like 'API unauthorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token, format: :json }
      end

      it 'should be success if access token is valid' do
        expect(response).to be_success
      end

      it 'returns list of question' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object includes #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context 'answers' do       
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "includes #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: options.merge(format: :json)
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    let!(:comment) { create(:comment_on_question, commentable: question) }
    let!(:attachment) { create(:attachment_on_question, attachmentable: question) }

    it_behaves_like 'API unauthorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get api_v1_question_path(question), params: { access_token: access_token.token, format: :json }
      end

      it 'should to be success if access token is valid' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "Question object includes #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      it_behaves_like 'Object with comments'
      it_behaves_like 'Object with attachments'
    end

    def do_request(options = {})
      get api_v1_question_path(question), params: options.merge(format: :json)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API unauthorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'valid params' do
        let(:question) { create(:question) }

        before do
          post api_v1_questions_path, params: { question: attributes_for(:question), access_token: access_token.token, format: :json }
        end

        it 'returns status code 201' do
          expect(response.status).to eq(201)
        end

        it 'creates a question' do
          expect(response.body).to be_json_eql(question.title.to_json).at_path('title')
        end
      end

      context 'invalid params' do
        before do
          post api_v1_questions_path, params: { question: { title: 'SomeTitle', body: nil }, access_token: access_token.token, format: :json }
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
    default = { question: attributes_for(:question), format: :json }
    post api_v1_questions_path, params: options.merge(default)
  end
end
