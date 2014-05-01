class AddEmailReminderToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :email, :boolean
  end
end
