class AddNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :number, :integer
  end
end
