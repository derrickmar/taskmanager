# create one new week for all users
namespace :admin do
    desc "Fill database with a new week for users"
    task new_weeks: :environment do
    	users = User.all
    	puts users
		users.each do |user|
			Week.create(user_id: user.id)
		end
    end
end