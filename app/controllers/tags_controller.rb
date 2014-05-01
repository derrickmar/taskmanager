class TagsController < ApplicationController
	$color_chooser = 0

	def index
	end

	def new
	end

	# if greater than length need to go back to 0
	def create
		# make sure the task id and tag id are the from the original user?
		puts params
		@task_to_associate = Task.find(params[:tag][:task_id])
		@existing_tag = Tag.find_by(name: params[:tag][:name], user_id: params[:tag][:user_id])
		if (@existing_tag != nil)
			# since the tags exists we are checking if this particular task already has a tag
			@tag_already_in_task = @task_to_associate.tags.find_by(name: params[:tag][:name], user_id: params[:tag][:user_id])
			if @tag_already_in_task == nil
				puts "IN HERE"
				@existing_tag.tasks << @task_to_associate
				respond_to do |format|
					format.html { redirect_to next_seven_days_user_path(current_user.id) }
					format.js { render partial: "create_existing" }
				end
			else
				puts "ALREADY PART OF TASK"
				# render another js that says you can't do that
				#redirect_to root_path
			end
		else
			length = TaskManager::Application::COLORS.length
			if $color_chooser > length - 1
				puts "reseting color_chooser"
				$color_chooser = 0
				@all_params = tag_params.merge(color: TaskManager::Application::COLORS[$color_chooser])
			else 
				@all_params = tag_params.merge(color: TaskManager::Application::COLORS[$color_chooser])
			end
			@tag = Tag.new(@all_params)
			if @tag.save
				# puts "VALUE OF color_chooser before"
				# puts $color_chooser
				$color_chooser = $color_chooser + 1
				# puts "VALUE OF color_chooser"
				# puts $color_chooser
				@tag.tasks << @task_to_associate
				respond_to do |format|
					format.html { redirect_to next_seven_days_user_path(current_user.id) }
					format.js
				end
			else
				render 'new'
			end
		end
	end

	# destroys the association between a tag and task. DOES NOT DESTORY THE TAG COMPLETELY
	def destroy
		puts "in tags controller destroy"
		puts params
		@tag = Tag.find(params[:id])
		@assoc_task = @tag.tasks.find(params[:assoc_task])
		@tag.tasks.delete(@assoc_task)
		render nothing: true
	end

	private
	def tag_params
		# will block task_id in create
		params[:tag].permit(:name, :user_id, :color)
	end
end
