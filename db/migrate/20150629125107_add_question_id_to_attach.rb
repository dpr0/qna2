class AddQuestionIdToAttach < ActiveRecord::Migration
  def change
    add_column :attaches, :question_id, :integer
    add_index :attaches, :question_id
  end
end
