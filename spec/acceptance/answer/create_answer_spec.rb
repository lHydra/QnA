require_relative '../acceptance_helper'

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

    fill_in 'answer_body', with: 'Some answer'
    click_on 'Create'

    within '.answers' do
      expect(page).to have_content 'Some answer'
    end
  end

  scenario 'User tries create not-valid answer', js: true do
    sign_in(user)
    visit questions_path
    click_on question.title

    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Guest tries to create answer', js: true do
    visit questions_path
    click_on question.title

    click_on 'Create'

    expect(page).to have_content('To answer a question, you must either sign up for an account')
  end
end
