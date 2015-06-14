require 'rails_helper'

feature 'Create answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question2) { create(:question, user: user2) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:answer2) { create(:answer, user: user2, question: question2) }

  scenario 'Authenticated user can create answer on the question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'text text'
    click_on 'Ответить'
    # expect(page).to have_content 'Ответ принят.'
    expect(page).to have_content 'text text'
  end
  scenario 'Author can delete his answer' do
    sign_in(user)
    answer
    visit question_path(question)
    expect(page).to have_content 'Del answer?'
  end
  scenario 'Author cant delete foreign answer' do
    sign_in(user)
    answer2
    visit question_path(question2)
    expect(page).to_not have_content 'Del answer?'
  end
end
