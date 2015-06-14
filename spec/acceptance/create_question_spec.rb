require 'rails_helper'

feature 'Create question', 'In order to get answer from community -  As an authenticated user - I want to be able to ask questions' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question2) { create(:question, user: user2) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:answer2) { create(:answer, user: user2, question: question2) }

  scenario 'Authenticated user creates question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'text text'
    click_on 'Подать вопрос'
    expect(page).to have_content 'Ok!'
    expect(page).to have_content 'Text question'
    expect(page).to have_content 'text text'
  end

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'user can view question list' do
    5.times { create :question, title: generate(:title) }
    visit questions_path
    # save_and_open_page
    expect(Question.count).to eq 5
    #expect(page).to have_content "Title Q#{пока не знаю как вставить регулярку для этой сиквенции}"
    expect(page).to have_content "Title Q1"
    expect(page).to have_content "Title Q2"
    expect(page).to have_content "Title Q3"
    expect(page).to have_content "Title Q4"
    expect(page).to have_content "Title Q5"
  end
  scenario 'user can view question and answers' do
    visit question_path(question)
    answer
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

  # Автор может удалить свой вопрос или ответ,
  # но не может удалить чужой вопрос/ответ
  scenario 'Author can delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Del?'
    expect(page).to have_content 'Question delete!'
  end
  scenario 'Author cant delete foreign question' do
    sign_in(user)
    visit question_path(question2)
    expect(page).to_not have_content 'Del?'
  end
end
