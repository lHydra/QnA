require "rails_helper"

RSpec.describe SubscriberMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:mail) { SubscriberMailer.subscriber_info(user, question) }

  it 'renders the header' do
    expect(mail.subject).to eq('There is a new answer')
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(['from@example.com'])
  end

  it 'body should contain the subscribed question' do
    expect(mail.body.encoded).to include(question.title)
  end
end
