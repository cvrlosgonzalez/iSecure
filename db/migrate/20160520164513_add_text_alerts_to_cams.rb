class AddTextAlertsToCams < ActiveRecord::Migration
  def change
    add_column :cams, :text_alerts, :boolean
  end
end
