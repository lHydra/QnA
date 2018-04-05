require_relative '../acceptance_helper'

feature 'create comment', %q{
  In order to specify details
  As an User
  I want to be able to commenting answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'User tries to commenting the answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers .comments' do
      fill_in 'comment_body', with: 'Some comment'
      click_on 'Create'
    end

    within '.answers .comments' do
      expect(page).to have_content('Some comment')
    end
  end
end
