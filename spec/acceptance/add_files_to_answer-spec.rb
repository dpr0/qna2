require_relative 'acceptance_helper'

feature 'Add files to answer' do

  given(:user) {create(:user)}
  given(:question) {create(:question)}


  background do
    sign_in(user)
    visit question_path(question)
  end
  scenario 'Authenticated user add file to answer' do
    fill_in 'Your answer', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Подать вопрос'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attach/file/1/spec_helper.rb'
      #expect(page).to have_content 'text text'
    end
  end

end