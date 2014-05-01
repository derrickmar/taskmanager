class FixTaskWeekIdName < ActiveRecord::Migration
  def change
  		rename_column :tasks, :week_id, :day_id
  end
end
