require_relative 'acceptance_helper'

feature 'Best answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:user3) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer)  { create(:answer, user: user, question: question) }
  given!(:answer2) { create(:answer, user: user2, question: question) }
  given!(:answer3) { create(:answer, user: user3, question: question) }

  # scenario 'Автор вопроса может выбрать лучший ответ для своего вопроса (лучший ответ может быть только 1)'
  # scenario 'Автор вопроса может выбрать другой ответ как лучший, если у вопроса уже выбран лучший ответ.'
  # scenario 'Если у вопроса выбран лучший ответ, то он отображается первым в списке ответов.'

  scenario 'unauthorized user dont sees button best answer' do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Best'
    end
  end

  scenario 'another user dont sees button best answer' do
    sign_in user2
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Best'
    end
  end

  describe 'authorized user:', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'user sees and press button best answer / choose another best answer' do
      within '.answers' do
        within "div#answer_#{answer3.id}.answer" do
          expect(page).to have_content 'Best'
          click_on 'Best'
        end
        visit question_path(question)
        within "div#answer_#{answer3.id}.answer" do
          expect(page).to have_content 'best answer'
          expect(page).to_not have_link 'Best'
        end
      end
    end

    scenario 'choose another best answer and check that the selected answer is not the best' do
      within '.answers' do
        within "div#answer_#{answer2.id}.answer" do
          click_on 'Best'
        end
        visit question_path(question)
        within "div#answer_#{answer2.id}.answer" do
          expect(page).to_not have_link 'Best'
          expect(page).to have_content 'best answer'
        end
        within "div#answer_#{answer3.id}.answer" do
          expect(page).to have_link 'Best'
          expect(page).to_not have_content 'best answer'
        end
      end
    end
  end
end
