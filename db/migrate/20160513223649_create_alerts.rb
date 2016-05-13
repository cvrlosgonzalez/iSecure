class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :last_event
      t.string :web_url
      t.string :image_url
      t.string :animated_url

      t.timestamps null: false
    end
  end
end
