class AddMonitoringAndApiNameToCams < ActiveRecord::Migration
  def change
    add_column :cams, :monitoring, :boolean
    add_column :cams, :api_name, :string
  end
end
