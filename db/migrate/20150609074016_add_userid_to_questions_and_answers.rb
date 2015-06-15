class AddUseridToQuestionsAndAnswers < ActiveRecord::Migration
  def change
    add_column :questions, :user_id, :integer
    add_column :answers,   :user_id, :integer
  end
  add_index :questions, :user_id, unique: true
  add_index :answers,   :user_id, unique: true
end
