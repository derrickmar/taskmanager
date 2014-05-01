class AddWeekIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :week_id, :integer
  end
end
