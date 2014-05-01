class RemoveWeekIdFromDays < ActiveRecord::Migration
  def change
    remove_column :days, :week_id, :integer
  end
end
