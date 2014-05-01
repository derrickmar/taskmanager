class RemoveDayFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :day, :string
  end
end
