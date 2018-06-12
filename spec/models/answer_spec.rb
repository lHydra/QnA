require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments) }
  it { should have_many(:comments) }
  it { should accept_nested_attributes_for :attachments }
  it { should validate_presence_of(:body) }

  describe '.send_email_to_subscribers' do
    let(:answer) { create(:answer, question: question) }
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before { user.subscribe!(question) }

    it 'should send email to subscribers after create new answer' do
      expect(SubscriberMailer).to receive(:subscriber_info).with(user, question).and_call_original
      answer
    end
  end
end
