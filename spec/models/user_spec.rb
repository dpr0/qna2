require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should validate_presence_of(:login) }
  it { should validate_length_of(:login).is_at_most(30) }
end
