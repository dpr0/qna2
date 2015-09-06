require_relative 'acceptance_helper'

feature 'question subscribe' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  #given(:subscription)  { create(:subscription, user: user, question: question) }

  scenario 'unauthorized user dont sees button subscribe' do
    visit question_path(question)
    within '.subscribe' do
      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  #user subscribes on a question automatically after its created!
  scenario 'user sees and press button Unsubscribe', js: true do
    sign_in user
    visit question_path(question)
    within '.subscribe' do
      expect(page).to have_content 'Unsubscribe'
      click_on 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  scenario 'authorized user sees and press button Subscribe', js: true do
    sign_in user2
    visit question_path(question)
    within '.subscribe' do
      expect(page).to have_content 'Subscribe'
      click_on 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
      expect(page).to_not have_link 'Subscribe'
    end
  end
end
