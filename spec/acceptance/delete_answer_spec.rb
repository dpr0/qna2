require_relative 'acceptance_helper'

feature 'Answer delete', 'Author of answer can to delete his answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:user2) { create(:user) }
  given(:answer3) { create(:answer, user: user2, question: question) }

  scenario 'Unauthenticated user try to delete answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Del?'
  end

  describe 'Authenticated user' do

    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'sees link to edit' do
      within '.answers' do
        expect(page).to have_link 'Del answer?'
      end
    end

    scenario 'try to delete his answer and another user answer', js: true do
    #scenario 'Переделать удаление ответов на ajax'
      expect(page).to have_content 'MyAnswer'
      expect(page).to have_content "Del answer?"
      click_on "Del answer?"
      expect(page).to_not have_content 'MyAnswer'

      answer3
      visit question_path(question)
      expect(page).to have_content 'MyAnswer'
      expect(page).to_not have_content "Del answer?"
    end
  end
end
