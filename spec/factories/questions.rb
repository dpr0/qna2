FactoryGirl.define do
  sequence(:title) { |i| "Title Q#{i}" }
  sequence(:body) { |i| "Text Q#{i}" }
  factory :question do
    title 'MyString'
    body 'MyText'
    user
  end
  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
