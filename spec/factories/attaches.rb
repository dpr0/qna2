FactoryGirl.define do
  factory :attach do
    file { File.new(Rails.root.join('spec', 'rails_helper.rb')) }
  end
end
