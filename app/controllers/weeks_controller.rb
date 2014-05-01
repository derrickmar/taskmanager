class WeeksController < ApplicationController
  # def index
  #   @weeks = Week.all
  # end

  # def show
  #   @week = Week.find(params[:id])
  #   @week_task = @week.tasks.build
  # end

  # def new
  #   @week = Week.new
  # end

  # def update
  #   puts "hello"
  #   render params
  #   @week = Week.find(params[:id])
  # end

  # def create
  #   puts "got here"
  #   puts params
  #   @new_week = Week.new
  #   @week = Week.create(user_id: params[:user_id])
  #   redirect_to user_weeks_user_path(current_user.id)
  # end

  # #strong parameters
  # private
  # def week_params
  #   params.require(:week).permit(:user_id, :id)
  # end
end
