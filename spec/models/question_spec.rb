require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attaches).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_length_of(:title).is_at_most(140) }
  it { should validate_length_of(:body).is_at_most(1000) }
  it { should accept_nested_attributes_for :attaches }
end
