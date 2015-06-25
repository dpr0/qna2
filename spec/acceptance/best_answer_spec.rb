require_relative 'acceptance_helper'

feature 'Answer delete', 'Author of answer can to delete his answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:user3) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:answer2) { create(:answer, user: user2, question: question) }
  given(:answer3) { create(:answer, user: user3, question: question) }

  #scenario 'Автор вопроса может выбрать лучший ответ для своего вопроса (лучший ответ может быть только 1)'
  #scenario 'Автор вопроса может выбрать другой ответ как лучший, если у вопроса уже выбран лучший ответ.'
  #scenario 'Если у вопроса выбран лучший ответ, то он отображается первым в списке ответов.'
  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'sees link to edit' do
  end
end
