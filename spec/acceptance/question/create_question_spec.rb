require_relative '../acceptance_helper'

feature 'create new question', %q{
  In order to be able receive the answers
  As an User
  I want to be able create new question
} do

  given(:user) { create(:user) }

  scenario 'Guest try to create new question' do
    visit new_question_path

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario 'User try to create new question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Some title'
    fill_in 'Body', with: 'Some body'
    click_on 'Create'

    expect(page).to have_content('Question was successfully created.')
  end
end
