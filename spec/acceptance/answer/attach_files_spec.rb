require_relative '../acceptance_helper.rb'

feature 'Adds files to the answer', %q{
  In order to illustrate the answer
  As an User
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds the file to the answer' do
    fill_in 'answer_body', with: 'Some answer'
    attach_file 'Attachment', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link('spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb')
    end
  end
end
