require_relative '../acceptance_helper'

feature 'Attach files', %q{
  In order to show details of the problem
  As an User
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds the file to the question' do
    fill_in 'Title', with: 'Some title'
    fill_in 'Body', with: 'Some body'
    attach_file 'Attachment', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Create'

    expect(page).to have_link('spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb')
  end
end
