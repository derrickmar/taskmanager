class AddColorCounterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cc, :integer, default: 0
  end
end
