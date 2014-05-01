# this will be triggered before a mail object gets sent so we can modify where the mail gets
# sent here
class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "DEVELOPMENT: #{message.subject}"
    message.to = "derrickmar1215@berkeley.edu"
  end
end