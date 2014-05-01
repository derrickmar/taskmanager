 require "#{Rails.root}/app/helpers/users_helper"
 include UsersHelper

 desc "Remind people by sms"
 task :daily_email => :environment do
  puts "in daily_email rake task!"

  users = User.all 

  users.each do |user|
    if user.settings(:settings).daily_email == "true"
      puts user.name + " is opting for daily emails"
      UsersHelper.set_overdue_tasks(user.id)
      today_tasks = user.days.where(date: Date.today).first.tasks
      array_of_overdue = UsersHelper.get_overdue_tasks(user.id)
      UserMailer.daily_tasks(user, today_tasks, array_of_overdue).deliver
    else 
      puts user.name + " is not opting for daily emails"
    end
  end
end