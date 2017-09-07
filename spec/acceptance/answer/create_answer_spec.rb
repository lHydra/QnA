require 'rails_helper'

feature 'create answer', %q{
  In order to exchange my knowledge
  As an User
  I want to be able create answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'User tries create answer', js: true do
    sign_in(user)
    visit questions_path
    click_on question.title

    fill_in 'Answer', with: 'Some answer'
    click_on 'Create'

    within '.answers' do
      expect(page).to have_content 'Some answer'
    end
  end
end
