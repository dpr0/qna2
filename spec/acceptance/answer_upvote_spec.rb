require_relative 'acceptance_helper'

feature 'upvote to the answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:user3) { create(:user) }
  given!(:question) { create(:question, user: user, votes_count: 0) }
  given(:question2) { create(:question, user: user2, votes_count: 0) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:answer2) { create(:answer, user: user2, question: question) }
  given(:answer3) { create(:answer, user: user3, question: question2) }

  scenario 'unauthorized user dont sees button Perfect' do
    visit question_path(question)
    within ".answer#answer_#{answer.id}" do
      expect(page).to_not have_link 'Perfect'
      expect(page).to_not have_link 'Bullshit'
    end
  end

  scenario 'question author dont sees button Perfect' do
    sign_in(user)
    visit question_path(question)
    within ".answer#answer_#{answer.id}" do
      expect(page).to_not have_link 'Perfect'
      expect(page).to_not have_link 'Bullshit'
    end
  end

  # если всключаю js: true - то вываливается ошибка гема dataTables: No route matches [GET] "/images/sort_both.png"
  scenario 'authorized user sees and press button Bullshit', js: true do
    sign_in(user2)
    visit question_path(question)
    within ".answer#answer_#{answer.id}" do
      expect(page).to have_link 'Bullshit'
      click_on 'Bullshit'
    end
    # visit question_path(question)
    within ".answer#answer_#{answer.id}" do
      expect(page).to_not have_link 'Bullshit'
      within '.votes_count' do
        expect(page).to have_content '-1 / -1'
      end
    end
  end

  scenario 'authorized user sees and press button Perfect, Cancel vote' do
    sign_in(user3)
    visit question_path(question)
    within ".answer#answer_#{answer.id}" do
      expect(page).to have_link 'Perfect'
      click_on 'Perfect'
    end
    visit question_path(question)
    within ".answer#answer_#{answer.id}" do
      expect(page).to_not have_link 'Perfect'
      expect(page).to_not have_link 'Bullshit'
      expect(page).to have_link 'Cancel vote'
      within '.votes_count' do
        expect(page).to have_content '1 / 1'
      end
      click_on 'Cancel vote'
    end
    visit question_path(question)
    within ".answer#answer_#{answer.id}" do
      expect(page).to have_link 'Perfect'
      expect(page).to have_link 'Bullshit'
      expect(page).to_not have_link 'Cancel vote'
      within '.votes_count' do
        expect(page).to have_content '0 / 0'
      end
    end
  end
end
