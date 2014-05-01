class UserMailer < ActionMailer::Base
  default from: "derrickmar1215@berkeley.edu"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:e
  #
  #   en.user_mailer.signup_confirmation.subject
  #
  def signup_confirmation(user)
    @user = user
    # generates mail and returns it
    # have this mail call at the end because we need to return it
    mail to:  "#{user.name} <#{user.email}>", subject: "Sign Up Confirmation"
  end

  # e-mails users of today's and overdue tasks
  def daily_tasks(user, today_tasks, overdue_tasks)
    @user = user
    @today_tasks = today_tasks
    @overdue_tasks = overdue_tasks
    mail to:  "#{user.name} <#{user.email}>", subject: "Task Manager Daily Update"
  end

  def email_reminder(user, task)
    @user = user
    @task = task
    mail to:  "#{user.name} <#{user.email}>", subject: "REMINDER"
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
end
