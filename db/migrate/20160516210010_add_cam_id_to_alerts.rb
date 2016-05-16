class AddCamIdToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :cam_id, :integer
  end
end
