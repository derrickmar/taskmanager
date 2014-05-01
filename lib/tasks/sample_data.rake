	namespace :db do
	desc "Fill database with sample data"
	# define a rake task called populate and ensures
	# that the Rake task has access to the local Rails environment,
	# including the User model

	task populate: :environment do
		# require 'factory_girl'
		# User.create!(name: "Derrick Mar2",
		# 	email: "derrick@berkeley.edu",
		# 	password: "foobar",
		# 	password_confirmation: "foobar")
		# puts "before factory"
		# FactoryGirl.create(:user)
		# 30.times do |n|
		# end
		# 1.time do |n|
		# 	name = Faker::Name.name # creates random names for us
		# 	email = "example-#{n+1}@railstutorial.org"
		# 	password = "password"
		# 	User.create!(name: name,
		# 		email: email,
		# 		password: password,
		# 		password_confirmation: password)
		# end

		User.create!(name: "Derrick Mar",
			email: "derrickmar1215@berkeley.edu",
			number: "6266226725",
			password: "foobar",
			password_confirmation: "foobar")

		# clubs
		Day.create(day: Date.yesterday.strftime("%A"), date: Date.yesterday, user_id: 1)
		kairos = Tag.create!(name: "Kairos", color: "#307429", user_id: 1)
		clubs = Tag.create!(name: "clubs", color: "#7B382F", user_id: 1)
		task1 = Task.create!(description: "Finish Kairos Presentation for retreat this weekend.", day_id: 16, important: false)
		task1.tags << kairos
		task1.tags << clubs

		# business
		business = Tag.create!(name: "business", color: "#643082", user_id: 1)
		task2 = Task.create!(description: "Ask Kenny about changing meeting time to  5:00 P.M.", day_id: 16, important: false)
		task2.tags << business

		#Family
		family = Tag.create!(name: "family", color: "#A84319", user_id: 1)
		task3 = Task.create!(description: "Call parents", day_id: 2, important: false)
		task3.tags << family
		task4 = Task.create!(description: "Pick up sister from airport", day_id: 1, important: false)
		task4.tags << family

		# HW
		hw = Tag.create!(name: "hw", color: "#327F64", user_id: 1)
		math = Tag.create!(name: "Math1B", color: "#846828", user_id: 1)
		task5 = Task.create!(description: "Math HW Random Variable Pg. 224 #13-29 odd", day_id: 5, important: false)
		task5.tags << hw
		task5.tags << math
		pp = Tag.create!(name: "PPC103", color: "#8A442D", user_id: 1)
		task6 = Task.create!(description: "Finish Public Policy Reading on Affordable Health Care Act", day_id: 6, important: false)
		task6.tags << hw
		task6.tags << pp
		cs = Tag.create!(name: "CS61C", color: "#287482", user_id: 1)
		task9 = Task.create!(description: "Finish CPU Processor design project", day_id: 4, important: false)
		task9.tags << hw
		task9.tags << cs
		task12 = Task.create!(description: "Finish User Interface reading on crowdsourcing", day_id: 4, important: false)
		cs160 = Tag.create!(name: "CS160", color: "#9937A1", user_id: 1)
		task12.tags << cs160
		task12.tags << hw

		# project tasks
		ts = Tag.create!(name: "TaskSimply", color: "#8F394B", user_id: 1)
		task7 = Task.create!(description: "Start creating the home page video for TaskSimply", day_id: 3, important: false)
		task7.tags << ts 
		task8 = Task.create!(description: "Correct text area resize issue when a user double clicks on the task", day_id: 7, important: false)
		task8.tags << ts

		#errands
		errands = Tag.create!(name: "errands", color: "#2C734A", user_id: 1)
		task10 = Task.create!(description: "Buy groceries at Costco\r\n- eggs\r\n- steak\r\n- milk\r\n- apples", day_id: 2, important: false)
		task10.tags << errands
		task11 = Task.create!(description: "Deposit checks from Cal Alumni Association", day_id: 3, important: false)
		task11.tags << errands
		task13 = Task.create!(description: "Errands Day!\r\n- drop sis at airpot\r\n- pick up apartment stuff from John\r\n- Get CS paper from Professor Bjoern", day_id: 6, important: false)


		# 


		puts "Finished sample user population"


	end
end