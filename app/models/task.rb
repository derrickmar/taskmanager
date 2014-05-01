# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  description :string(255)
#  important   :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  day_id      :integer
#  complete    :boolean
#  ordering    :integer          default(0)
#  user_id     :integer
#  due_at      :datetime
#  overdue     :boolean
#  email       :boolean
#

class Task < ActiveRecord::Base
  before_create :default_values
  validates :description, presence: true
  validates :day_id, presence: true
  belongs_to :day
  has_and_belongs_to_many :tags, join_table: "tasks_tags"
  #belongs_to :user 
  default_scope -> { order('ordering ASC') }

  private
  def default_values
    if self.complete == nil
      self.complete = false
    end
    if self.important == nil
      self.important = false
    end
    if self.overdue == nil
      self.overdue = false
    end
    if self.email == nil
      self.email = false
    end
    return true
  end
end
