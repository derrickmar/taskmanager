class PasswordResetsController < ApplicationController
	def create
		user = User.find_by_email(params[:email])
		user.send_password_reset if user
		flash[:success] = "Email sent with password reset instructions."
		redirect_to root_url
	end

	def edit
		puts "IN EDIT PasswordResetsController"
		puts params 
		@user = User.find_by_password_reset_token!(params[:format])
	end

	def update
		puts "IN UPDATE PasswordResetsController"
		puts params 
		@user = User.find_by_password_reset_token!(params[:format])
		puts @user.name
		if @user.password_reset_sent_at < 2.hours.ago
			flash[:danger] = "Password reset has expired. Please request another e-mail"
			redirect_to new_password_reset_path
		elsif @user.update_attributes(password_strong_params)
			flash[:success] = "Password has been reset! Please login."
			redirect_to signin_path
		else
			render :edit
		end
	end

	private
	def password_strong_params
		params[:user].permit(:password, :password_confirmation)
	end

end
