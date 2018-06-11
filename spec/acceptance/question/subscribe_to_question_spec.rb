require_relative '../acceptance_helper.rb'

feature 'Subscribe to question', %q{
  In order to follow the question
  As an User
  I want to be able to subscribe to question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User can subscribe to question', js: true do
    click_on 'subscribe'

    expect(page).to have_content('За вопросом следят 1 человек')
    expect(page).to have_button('unsubscribe')
  end

  scenario 'User can unsubscribes to question', js: true do
    click_on 'subscribe'
    click_on 'unsubscribe'

    expect(page).to have_content('За вопросом следят 0 человек')
    expect(page).to have_button('subscribe')
  end
end
