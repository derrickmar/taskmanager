class AddTaskTagsTableAgain < ActiveRecord::Migration
  def change
  	create_table :tasks_tags do |t|
      t.belongs_to :task
      t.belongs_to :tag

    end
  end
end
