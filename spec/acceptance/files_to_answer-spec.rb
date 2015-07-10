require_relative 'acceptance_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:attach) { create(:attach, attachable: answer) }

  background do
    sign_in(user)
    visit question_path(question)
  end
  scenario 'the authenticated user adds the file when you create answer', js: true do
    fill_in 'Your answer', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ответить'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attach/file/1/spec_helper.rb'
    end
  end

  scenario 'The authenticated user delete file from answer', js: true do
  fill_in 'Your answer', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ответить'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attach/file/1/spec_helper.rb'
      click_on 'Удалить spec_helper.rb?'
      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attach/file/1/spec_helper.rb'
    end  
  end

  scenario 'the authenticated user adds the file when you create answer', js: true do
    fill_in 'Your answer', with: 'text text'
    click_on 'add file'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Ответить'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attach/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attach/file/2/rails_helper.rb'
    end
  end
  
end
