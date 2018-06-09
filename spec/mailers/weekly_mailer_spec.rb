require "rails_helper"

RSpec.describe WeeklyMailer, type: :mailer do
  let(:user) { create(:user) }
  let!(:question) { create(:question, created_at: 1.day.ago) }
  let!(:question2) { create(:question, title: 'On this week', created_at: 1.day.since) }
  let!(:mail) { WeeklyMailer.weekly_digest(user) }

  it 'renders the header' do
    expect(mail.subject).to eq('Weekly digest from QnA')
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(['digest@example.com'])
  end

  it 'body should contain a question created during the previous week' do
    expect(mail.body.encoded).to include(question.title)
  end

  it 'body should not contain a question created after the day of the mailing' do
    expect(mail.body.encoded).not_to include(question2.title)
  end
end
