class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.string :day
      t.date :date
      t.boolean :complete
      t.integer :user_id

      t.timestamps
    end
  end
end
