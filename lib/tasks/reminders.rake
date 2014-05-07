 desc "Remind people by sms"
  task :remind_sms => :environment do
    puts "in rake remind_sms!"
    Time.zone = 'America/Los_Angeles'
    d = Time.now


    tasks = Task.select {|task| task.due_at != nil &&
      d > task.due_at - (5.minutes + 30.seconds) &&
      d < task.due_at + 5.minutes &&
      !User.find(task.day.user_id).number.blank?
    }

    @client = Twilio::REST::Client.new(TaskManager::Application.config.twilio_sid,
                                        TaskManager::Application.config.twilio_token)

    tasks.each do |t|
      body = "Reminder: " + t.description
      puts t.description
      number = User.find(t.day.user_id).number
      puts "sending reminder to: " +  number
      @client.account.messages.create(:body => body,
                  :to => number,
                  :from => TaskManager::Application.config.twilio_phone_number)
      if t.email
        puts "e-mailing a task to " + User.find(t.day.user_id).name
        UserMailer.email_reminder(User.find(t.day.user_id), t).deliver
      end
    end
  end