class CreateCams < ActiveRecord::Migration
  def change
    create_table :cams do |t|
      t.string :title
      t.string :alert

      t.timestamps null: false
    end
  end
end
