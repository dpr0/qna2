require_relative 'acceptance_helper'

feature 'Create question', 'In order to get answer from community -  As an authenticated user - I want to be able to ask questions' do
  given(:user) { create(:user) }
  given!(:question)  { create(:question, user: user) }
  given!(:question2) { create(:question, user: user) }
  given!(:answer)    { create(:answer, user: user, question: question) }
  given!(:answer2)   { create(:answer, user: user, question: question2) }
  #ThinkingSphinx::Test.init
  #ThinkingSphinx::Test.start
  #ThinkingSphinx::Test.index

  scenario 'Authenticated user search', sphinx: true do
    ThinkingSphinx::Test.run do
      sign_in(user)
      visit questions_path
      page.choose('Questions')
      fill_in 'Search:', with: 'MyText'
      click_on 'Search'
      within '.search_result' do
        expect(page).to have_content 'Founded:'
        expect(page).to have_content question.text
      end
    end
  end

  scenario 'Non-authenticated user search', sphinx: true do
    ThinkingSphinx::Test.run do
      visit questions_path
      fill_in 'search_field', with: 'Text question'
      click_on 'Search'
      expect(page).to have_content 'Founded:'
      expect(page).to have_content 'No matches!'
    end
  end
end
