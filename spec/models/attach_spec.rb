require 'rails_helper'

RSpec.describe Attach, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  it { should belong_to :question }
end
