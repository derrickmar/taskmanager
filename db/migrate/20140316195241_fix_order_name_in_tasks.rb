class FixOrderNameInTasks < ActiveRecord::Migration
  def change
  	rename_column :tasks, :order, :ordering
  end
end
