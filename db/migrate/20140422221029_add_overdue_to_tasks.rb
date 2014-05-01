class AddOverdueToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :overdue, :boolean
  end
end
