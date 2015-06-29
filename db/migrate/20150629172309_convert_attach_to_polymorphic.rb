class ConvertAttachToPolymorphic < ActiveRecord::Migration
  def change
    remove_index :attaches, :question_id
    rename_column :attaches, :question_id, :attachable_id
    add_column :attaches, :attachable_type, :string
    add_index :attaches, [:attachable_id, :attachable_type]
  end
end
