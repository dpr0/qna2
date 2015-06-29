require_relative 'acceptance_helper'

feature 'Add files to question' do

  given(:user) {create(:user)}

  background do
    sign_in(user)
    visit new_question_path
  end
  scenario 'Authenticated user add file when create question' do
    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Подать вопрос'
    expect(page).to have_content 'spec_helper.rb'
  end

end