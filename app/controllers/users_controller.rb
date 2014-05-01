class UsersController < ApplicationController
	include UsersHelper
	before_action :signed_in_user, only: [:index, :edit, :update, :sign_in_user]
	before_action :correct_user, only: [:edit, :update]

	def update_settings
		# currently not using no_tags_shown because I think it's no neccessary. Should always
		# be checked on reload
		puts params
		@user = User.find(params[:id])
		@user.settings(:settings).update_attributes! user_settings_params
		puts "after_update"
		#puts @user.settings(:settings).view
		render nothing: true
	end

	def number
		puts params
		# puts "in number"
		# puts params[:user][:number]
		# puts params.require(:user).permit(:number)
		@user = User.find(params[:id])
		@number = params[:user][:number]
		if @user.update_attributes(number: params[:user][:number])
			@failed = false
			respond_to do |format|
				format.html { render 'edit' }
				format.js
			end
		else
			@failed = true
			respond_to do |format|
				format.html { render 'edit' }
				format.js
			end
		end
	end

	# def search_tags
	# 	if params[:search]
	# 		@tags = Tag.search(params[:search]).order("created_at DESC")
	# 	else
	# 		@tags = Tag.all.order('created_at DESC')
	# 	end
	# 	redirect_to next_seven_days_user_path(current_user.id)
	# end

	def next_seven_days
		@user = User.find(params[:id])
		# @overdue_tasks = overdue_tasks(@user.id)
		puts "calling overdue_tasks"
		set_overdue_tasks(@user.id)
		# puts @overdue
		puts "IN next_seven_days ACTION OF USERS"
		#puts "current user: " + current_user.id.to_s
		@next_seven = get_next_seven_days(current_user.id)
		@first_day = @next_seven[0]
		@second_day = @next_seven[1]
		@third_day = @next_seven[2]
		@fourth_day = @next_seven[3]
		@fifth_day = @next_seven[4]
		@sixth_day= @next_seven[5]
		@seventh_day = @next_seven[6]

		@tags = get_tags_for_next_seven_days(@next_seven)

		# @overdue_tasks.each do |task|
		# 	overdue_tags = task.tags
		# 	overdue_tags.each do |tag|
		# 		if !@tags.include?(tag)
		# 			@tags << tag
		# 		end
		# 	end
		# end

		# get tasks from th e next seven days.
		# add overdue tasks to that
	end

	# is there really a need for this? Answer right now: no
	# def delete_tags_for_next_seven_days
	# end
	def index
		puts "IN INDEX ACTION OF USERS"
		puts params
		@users = User.paginate(page: params[:page])
	end

	# def user_weeks
	# 	@user = User.find(params[:id])
	# 	@weeks = Week.all
	# end

	def happy
		render nothing: true
	end

	def show
		@user = User.find(params[:id])
	end

	# def sms_empty
	# 	@user = User.find(params[:id])
	# 	render "sms_empty_notice"
	# end

	def new
		puts "IN NEW ACTION OF USERS"
		@user = User.new
	end

	def create
		puts "IN CREATE ACTION OF USERS"
		puts params
		@user = User.new(user_params)
		if @user.save
			# calling deliver on a mail object
			UserMailer.signup_confirmation(@user).deliver
			sign_in @user
			flash[:success] = "Welcome to the Task Manager!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit_avatar
		# puts params
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end

	# renders the form ()
	def edit
	end

	# does the update action when form is submitted
	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to edit_user_path
		else
			render 'edit'
		end
	end

	def destroy
		puts "DELETING USER"
		User.find(params[:id]).destroy
		flash[:success] = "User deleted."
		redirect_to root_url
	end	

	# def dailytasks
	# 	UserMailer.signup_confirmation(@user).deliver
	# end

	# everything below will be private
	private

	def get_tags_for_next_seven_days(seven_days)
		tagsAry = Array.new
		seven_days.each do |day|
			tasks = day.tasks
			tasks.each do |task|
				tags = task.tags
				tags.each do |tag|
					if !tagsAry.include?(tag)
						tagsAry << tag
					end
				end
			end
		end
		return tagsAry
	end

	def get_next_seven_days(userId)
		puts "IN get_next_seven_days"
		puts userId.to_s
		seven_days = Day.where("date >= :start AND date < :end AND user_id = :user_id",
			user_id: userId,
			start: Date.today,
		end: 1.week.from_now.to_date,
		order: "date ASC")
		return seven_days
	end

	def user_params
		params.require(:user).permit(:name, :email, :password,
			:password_confirmation, :number, :avatar)
	end

	def user_settings_params
		params.permit(:view, :completed_hidden, :daily_email)
	end

	# Before filters
	def signed_in_user
		unless signed_in?
			# if not signed in the store the location of the url
			store_location
			flash[:notice] = "Please sign in."
			redirect_to signin_url
		end
	end

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end
end
