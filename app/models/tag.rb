# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  color      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Tag < ActiveRecord::Base
	has_and_belongs_to_many :tasks, join_table: "tasks_tags"
	belongs_to :user
	validates_uniqueness_of :name, scope: :user_id
	#validates_uniqueness_of :name, scope: :task_id
	validates :user_id, presence: true
	#validates :task_id, presence: true

	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end

end
