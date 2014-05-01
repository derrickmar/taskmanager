module UsersHelper

	def gravatar_for(user, options = { size: 50 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		# convenient for site_impaired users
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end

	def set_overdue_tasks(userId)
		user = User.find(userId)
		# this is grabbing all the past days for the user. May be really inefficient
		# as the number of days grows
		past_days = user.days.where("date < :start", start: Date.today).order("date ASC")
		ary = Array.new
		today = user.days.where(date: Date.today).first
		#first_one = true
		past_days.each do |day|
			tasks = day.tasks.where(complete: false)
			tasks.each do |task|
				task.update(day_id: today.id)
				task.update(overdue: true)
				# ary << task
			end
		end
		# return ary
	end

	def get_overdue_tasks(userId)
		list_of_overdue = Array.new
		user = User.find(userId)
		days_before_tomorrow = user.days.where("date < :start", start: Date.tomorrow).order("date ASC")
		days_before_tomorrow.each do |day|
			tasks = day.tasks.where(overdue: true)
			tasks.each do |task|
				list_of_overdue << task
			end
		end
		return list_of_overdue
	end

end