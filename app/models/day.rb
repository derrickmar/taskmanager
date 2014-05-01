# == Schema Information
#
# Table name: days
#
#  id         :integer          not null, primary key
#  day        :string(255)
#  date       :date
#  complete   :boolean
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Day < ActiveRecord::Base
	#before_create :default_values
	has_many :tasks
	belongs_to :user
	validates :user_id, presence: true

	private
	def default_values
		self.complete ||= false
		return true
	end
	
end
