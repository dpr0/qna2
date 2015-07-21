require_relative 'acceptance_helper'

feature 'Answer edit', 'Author of answer can to edit his answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  given(:user2) { create(:user) }
  given(:question2) { create(:question, user: user2) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:answer2) { create(:answer, user: user2, question: question2) }
  given(:answer3) { create(:answer, user: user, question: question2) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Редактировать ответ?'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'sees link to edit' do
      within '.answers' do
        expect(page).to have_link 'Редактировать ответ?'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Редактировать ответ?'
      within '.answers' do
        fill_in 'Текст ответа:', with: 'Ответ отредактирован.'
        click_on 'Сохранить'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Ответ отредактирован.'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit other user answer' do
      # scenario 'Пользователь видит ссылку РедОтв? если он автор этого ответа'
      # scenario 'Только автор может отредактировать свой ответ'
      question2
      answer2
      # answer3 # для проверки что выдаст ошибку
      visit question_path(question2)
      within '.answers' do
        expect(page).to_not have_link 'Редактировать ответ?'
      end
    end

    scenario 'Только автор может отредактировать свой вопрос' do
      expect(page).to have_link 'Редактировать вопрос?'
    end
  end
end
