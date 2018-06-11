require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:authorizations) }
  it { should have_many(:subscriptions) }
  it { should have_many(:subscribed_questions) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'when user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq(user)
      end
    end

    context 'when user has not authorization' do
      context 'when user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email } ) }
        
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = user = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq(user)
        end
      end

      context 'when user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' } ) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq(auth.info[:email])
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations.first).to be_a(Authorization)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end
      end
    end
  end

  describe '.weekly_mailing' do
    let!(:users) { create_list(:user,2) }

    it 'should send weekly digest to all users' do
      users.each { |user| expect(WeeklyMailer).to receive(:weekly_digest).with(user).and_call_original }
      User.weekly_mailing
    end
  end

  describe '.subscribe' do
    let(:question) { create(:question) }
    let!(:user) { create(:user) }

    it 'should create relation with question' do
      user.subscribe!(question)
      expect(user.subscribed_questions).to include(question)
    end
  end

  describe '.unsubscribe' do
    let(:question) { create(:question, user: user) }
    let!(:user) { create(:user) }

    before do
      user.subscribe!(question)
    end

    it 'should destroy relation with question' do
      user.unsubscribe!(question)
      expect(user.subscribed_questions).not_to include(question)
    end
  end
end
