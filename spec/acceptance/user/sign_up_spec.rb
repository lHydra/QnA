require_relative '../acceptance_helper'

feature 'User sign up', %q{
  In order to be able to sign in
  As an User
  I want to be able to sign up
} do

  scenario 'Guest try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@mail.ru'
    fill_in 'Password', with: 'qwerty', match: :prefer_exact
    fill_in 'Password confirmation', with: 'qwerty'
    click_on 'Sign up'

    expect(page).to have_content('You have signed up successfully')
    expect(current_path).to eq(root_path)
  end

end
