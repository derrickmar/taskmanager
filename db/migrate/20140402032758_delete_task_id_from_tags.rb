class DeleteTaskIdFromTags < ActiveRecord::Migration
  def change
  	remove_column :tags, :task_id
  end
end
