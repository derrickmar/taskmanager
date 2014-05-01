require 'twilio-ruby'

class TwilioController < ApplicationController
	include Webhookable

	after_filter :set_header

   #The purpose of the voice action is to tell Twilio what to do when someone calls
   #your Twilio number. In this case, we make use of the twilio-ruby helper library to
   #build a response object and then render that response object as TwiML. 
   def voice
   	response = Twilio::TwiML::Response.new do |r|
   		r.Say 'Hey there. Congrats on integrating Twilio into your Rails 4 app.', :voice => 'alice'
   		r.Play 'http://linode.rabasa.com/cantina.mp3'
   	end

   	render_twiml response
   end

   def message
    @user = current_user
    puts "params: "
    puts params
    # Get your Account Sid and Auth Token from twilio.com/user/account
    account_sid = TaskManager::Application.config.twilio_sid
    # puts "printing token"
    #puts TaskManager::Application.config.twilio_token
    auth_token = TaskManager::Application.config.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token

    message = @client.account.messages.create(:body => "Hola! This is a test message from TaskSimply!",
    	:to => @user.number,
    	:from => TaskManager::Application.config.twilio_phone_number)
    flash[:success] = "Test message sent!"
    redirect_to edit_user_path(current_user.id)
  end
end