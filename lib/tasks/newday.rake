 desc "Remind people by sms"
 task :new_day => :environment do
  puts "in rake newday!"
  Time.zone = 'America/Los_Angeles'
  d = Time.now

  @users = User.all 
  @users.each do |user|
    puts user.name
    @next_date = user.days.order('date DESC').first.date.tomorrow
    a_day = Day.create(day: @next_date.strftime("%A"), date: @next_date, user_id: user.id)
    puts "created for user " + user.id.to_s + " day is " + a_day.day + " and " + a_day.date.to_s + ": " + a_day.id.to_s
  end
end