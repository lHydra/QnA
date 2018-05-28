require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  In order to fix mistake
  As an author of answer
  I want to be able edit answer
} do
  given(:author) { create(:user) }
  given(:guest) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Guest tries to edit answer' do
    visit question_path(question)
    expect(page).not_to have_link('Edit answer')
  end

  scenario 'Authenticated user tries to edit other user`s answer' do
    sign_in(guest)

    visit question_path(question)
    expect(page).not_to have_link('Edit answer')
  end

  scenario 'Author tries to edit answer', js: true do
    sign_in(author)

    visit question_path(question)
    click_on 'Edit answer'

    within '.answers' do
      fill_in 'answer_body', with: 'Edited answer'
      click_on 'Save'
    end

    within '.answers' do
      expect(page).to have_content 'Edited answer'
      expect(page).not_to have_content answer.body
    end
  end
end
