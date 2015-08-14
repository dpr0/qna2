require_relative 'acceptance_helper'
require 'rails_helper'

feature 'sign in with' do

  it "vkontakte" do
    visit '/'
    click_on 'Войти'
    expect(page).to have_content("Sign in with Vkontakte")
    mock_auth_hash
    click_on "Sign in with Vkontakte"
    expect(page).to have_content 'testvk@mail.com'
    expect(page).to have_content 'Выйти'
    expect(page).to have_content 'Successfully authenticated from VKONTAKTE account.'
  end

  it "facebook" do
    visit '/'
    click_on 'Войти'
    expect(page).to have_content("Sign in with Facebook")
    mock_auth_hash
    click_on "Sign in with Facebook"
    expect(page).to have_content 'testfb@mail.com'
    expect(page).to have_content 'Выйти'
    expect(page).to have_content 'Successfully authenticated from FACEBOOK account.'
  end

  it "authentication error" do
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
    visit '/'
    click_on 'Войти'
    expect(page).to have_content("Sign in with Vkontakte")
    click_on "Sign in with Vkontakte"
    expect(page).to have_content('Could not authenticate you from Vkontakte')
  end

end
