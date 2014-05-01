class AddUserIdAndTaskIdToTag < ActiveRecord::Migration
  def change
    add_column :tags, :user_id, :integer
    add_column :tags, :task_id, :integer
  end
end
