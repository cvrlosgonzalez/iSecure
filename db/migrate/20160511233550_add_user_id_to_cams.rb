class AddUserIdToCams < ActiveRecord::Migration
  def change
    add_column :cams, :user_id, :integer
    add_index :cams, :user_id
  end
end
