env :PATH, "/Users/dmar/Dropbox/rails_projects/task_manager/path/ruby/2.0.0/cache/bundler/git/database_cleaner-b24a9459ef45b985266c5e787112f8b3a49af4b4"

set :environment, :development

set :output, "#{path}/log/cron.log"

every 1.minute do
  rake "admin:new_weeks", environment: 'development'
end

# every 1.day, :at => '2:49 am' do
#   rake "admin:new_weeks"
# end

# every :monday, :at => '12:01 am' do
#   rake "admin:new_weeks"
# end