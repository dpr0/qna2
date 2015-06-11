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
    # save_and_open_page
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'text text'
    click_on 'Подать вопрос'
    expect(page).to have_content 'Ok!'
  end

  scenario 'Non-authenticated user ties  to create question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'user can view question list' do
    visit questions_path
    expect(page).to have_content 'Ask question'
  end
  scenario 'user can view question and answers' do
    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

  scenario 'Authenticated user can create answer on the question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'text text'
    click_on 'Ответить'
    expect(page).to have_content 'Ответ принят.'
  end

  scenario 'Authenticated user can create answer on the question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'text text'
    click_on 'Ответить'
    expect(page).to have_content 'Ответ принят.'
  end

  scenario 'Only authenticated user can make questions and answers' do
    sign_in(user)
    click_on 'Задать вопрос'
    expect(page).to have_content 'Задайте вопрос:'
  end

  scenario 'Only authenticated user can make questions and answers' do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'title title'
    fill_in 'Body', with: 'body body'
    click_on 'Подать вопрос'
    expect(page).to have_content 'Ok!'
  end
  # Автор может удалить свой вопрос или ответ,
  # но не может удалить чужой вопрос/ответ
  scenario 'Author can delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Del?'
    expect(page).to have_content 'Question delete!'
  end
  scenario 'Author can delete his answer' do
    sign_in(user)
    visit question_path(question)
    #click_on 'Del answer?'
    #expect(page).to have_content 'Answer delete!'
  end
  scenario 'Author cant delete foreign question' do
    sign_in(user)
    visit question_path(question2)
    click_on 'Del?'
    expect(page).to have_content 'not your question'
  end
  scenario 'Author cant delete foreign answer' do
    sign_in(user)
    visit question_path(question2)
    expect(page).to_not have_content 'Del answer?'
  end
end
