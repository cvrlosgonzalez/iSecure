class AddPnumberToUser < ActiveRecord::Migration
  def change
    change_column :users, :pnumber, :string
  end
end
