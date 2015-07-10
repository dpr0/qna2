require_relative 'acceptance_helper'

feature 'files to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:attach) { create(:attach, attachable: question) }

  background do
    sign_in(user)
  end

  scenario 'The authenticated user adds the file when you create question' do
    visit new_question_path
    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Подать вопрос'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attach/file/1/spec_helper.rb'
  end

  scenario 'The authenticated user delete file from question' do
    visit question_path(attach.attachable)
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attach/file/2/rails_helper.rb'
    click_on "Удалить rails_helper.rb?"
    expect(page).to_not have_link 'rails_helper.rb', href: '/uploads/attach/file/2/rails_helper.rb'
  end

  scenario 'The authenticated user adds some files when you create question', js: true do
    visit new_question_path
    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'text text'
    click_on 'add file'
    click_on 'add file'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    inputs[2].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Подать вопрос'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attach/file/3/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attach/file/4/rails_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attach/file/5/rails_helper.rb'
  end

end