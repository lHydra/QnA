require_relative '../acceptance_helper'

feature 'create comment', %q{
  In order to specify details
  As an User
  I want to be able to commenting question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'User tries to commenting the question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question .comments' do
      fill_in 'comment_body', with: 'Some comment'
      click_on 'Create'
    end

    within '.question .comments' do
      expect(page).to have_content('Some comment')
    end
  end
end
