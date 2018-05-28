require_relative '../acceptance_helper'

feature 'Edit question', %q{
  In order to be able add information to the question
  As an User
  I want to be able edit the question
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Guest tries to edit question' do
    visit question_path(question)
    expect(page).not_to have_link('Edit')
  end

  scenario 'User tries to edit someone else`s question' do
    sign_in(user)

    visit question_path(question)
    expect(page).not_to have_link('Edit')
  end

  scenario 'User tries to edit his question' do
    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: 'Some title'
    fill_in 'Body', with: 'Some body'
    click_on 'Create'

    click_on 'Edit'
    fill_in 'Title', with: 'Updated title'
    fill_in 'Body', with: 'Updated body'
    click_on 'Update'

    expect(page).to have_content('Updated title')
  end
end
