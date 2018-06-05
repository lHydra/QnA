require 'rails_helper'

describe 'Profile api' do
  describe 'GET #me' do
    it_behaves_like 'API unauthorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 if access token is valid' do
        expect(response.status).to eq(200)
      end

      %w(email created_at updated_at).each do |attr|
        it "includes #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end
      
      %w(password encrypted_password).each do |attr|
        it "doesn`t include #{attr}" do
          expect(response.body).not_to have_json_path("#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: options.merge(format: :json)
    end
  end

  describe 'GET #show' do
    it_behaves_like 'API unauthorizable'

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: current_user.id) }
      let(:current_user) { users.first }
      let(:user) { users.second }

      before do
        get '/api/v1/profiles', params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'returns list of users except current user' do
        expect(response.body).to have_json_size(2)
      end

      2.times do |i|
        it 'doesn`t include current user' do
          expect(response.body).to_not be_json_eql(current_user.email.to_json).at_path("#{i}")
        end
      end

      %w(email created_at updated_at).each do |attr|
        it "includes #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
      
      %w(password encrypted_password).each do |attr|
        it "doesn`t include #{attr}" do
          expect(response.body).not_to have_json_path("0/#{attr}")
        end
      end
    end
  end

  def do_request(options = {})
    get '/api/v1/profiles', params: options.merge(format: :json)
  end
end
