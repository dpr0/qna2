require_relative 'acceptance_helper'

feature 'upvote to the question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:user3) { create(:user) }
  given!(:question) { create(:question, user: user, votes_count: 0) }
  given(:question2) { create(:question, user: user2, votes_count: 0) }

  scenario 'unauthorized user dont sees button Perfect' do
    visit questions_path
    expect(page).to_not have_link 'Perfect'
    expect(page).to_not have_link 'Bullshit'
    visit questions_path(question)
    expect(page).to_not have_link 'Perfect'
    expect(page).to_not have_link 'Bullshit'
  end

  scenario 'question author dont sees button Perfect' do
    sign_in(user)
    expect(page).to_not have_link 'Perfect'
    expect(page).to_not have_link 'Bullshit'
    visit questions_path(question)
    expect(page).to_not have_link 'Perfect'
    expect(page).to_not have_link 'Bullshit'
  end

  # если всключаю js: true - то вываливается ошибка гема dataTables: No route matches [GET] "/images/sort_both.png"
  scenario 'authorized user sees and press button Bullshit' do # , js: true do
    sign_in(user2)
    visit questions_path
    within ".question_#{question.id}" do
      expect(page).to have_link 'Bullshit'
      # save_and_open_page
      click_on 'Bullshit'
    end
    visit questions_path
    within ".question_#{question.id}" do
      expect(page).to_not have_link 'Bullshit'
      within '.votes_count' do
        expect(page).to have_content '-1 / -1'
      end
    end
  end

  scenario 'authorized user sees and press button Perfect, Cancel vote' do
    sign_in(user3)
    within ".question_#{question.id}" do
      expect(page).to have_link 'Perfect'
      click_on 'Perfect'
    end
    visit questions_path
    within ".question_#{question.id}" do
      expect(page).to_not have_link 'Perfect'
      expect(page).to_not have_link 'Bullshit'
      expect(page).to have_link 'Cancel vote'
      within '.votes_count' do
        expect(page).to have_content '1 / 1'
      end
      click_on 'Cancel vote'
    end
    visit questions_path
    within ".question_#{question.id}" do
      expect(page).to have_link 'Perfect'
      expect(page).to have_link 'Bullshit'
      expect(page).to_not have_link 'Cancel vote'
      within '.votes_count' do
        expect(page).to have_content '0 / 0'
      end
    end
  end
end
