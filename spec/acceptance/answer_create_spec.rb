require_relative 'acceptance_helper'

feature 'User answer', ' In order to exchange my knowledge - As an authenticated user - I want to be able to create answers ' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:question2) { create(:question, user: user2) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:answer2) { create(:answer, user: user2, question: question2) }

  background { sign_in user }
  scenario 'User try to create invalid answer', js: true do
    visit question_path(question)
    click_on 'Ответить'
    within '.answer-errors' do
      expect(page).to have_content 'Body is too short'
    end
  end

  scenario '1 question & 1 answer, +1 answer', js: true do
    create(:answer, question: question, body: 'Text 1')
    visit question_path(question)
    fill_in 'Your answer', with: 'Text 2'
    click_on 'Ответить'
    # expect(current_path).to eq question_path(question) 
    within '.answers' do
      expect(page).to have_content 'Text 1'
      expect(page).to have_content 'Text 2'
    end
  end

  scenario 'Authenticated user create answer', js: true do
    visit question_path(question)
    fill_in 'Your answer', with: 'text text'
    click_on 'Ответить'
    # pp current_path
    # visit question_path(question)
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'text text'
    end
  end

  scenario 'Authenticated user can create answer on the question', js: true do
    visit question_path(question)
    fill_in 'Your answer', with: 'text text'
    click_on 'Ответить'
    # expect(page).to have_content 'Ответ принят.'
    expect(page).to have_content 'text text'
  end
  scenario 'Author can delete his answer' do
    answer
    visit question_path(question)
    expect(page).to have_content 'Del answer?'
  end
  scenario 'Author cant delete foreign answer' do
    answer2
    visit question_path(question2)
    expect(page).to_not have_content 'Del answer?'
  end
end
