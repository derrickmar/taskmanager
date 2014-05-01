class TasksController < ApplicationController
  include StaticPagesHelper

  def create
    puts "IN CREATE ACTION"
    puts params
    # puts "THIS IS THE DUE_AT VALUE"
    # puts task_params[:due_at]
    @curr_day = Day.find(params[:day_id])

    # due_at is type string but Rails knows how to convert that to datetime when saved
    @day_task = @curr_day.tasks.build(task_params)
    if @day_task.save
      respond_to do |format|
        format.html { redirect_to next_seven_days_user_path(current_user.id) }
        format.js # no block because we are rendering create.js.erb
      end
    else
      puts "CANNOT CREATE TASK WITH EMPTY NAME"
      puts @day_task.errors
      puts params
      # respond_to do |format|
      #   format.html { redirect_to next_seven_days_user_path(current_user.id) }
      #   format.js # no block because we are rendering create.js.erb
      # end
      redirect_to next_seven_days_user_path(current_user.id)
    end
  end

  def gcal
      puts "in gcal action"
      puts params
      @task = Task.find(params[:id])
      puts "due_at"
      puts @task.due_at
      @link = gcal_link(@task)
      puts @link
      redirect_to @link
  end

  def edit_text
    puts params
    @task = Task.find(params[:id])
    @task.update(description: params[:new_description])
    render nothing: true
  end

  def time
    puts params
    @task = Task.find(params[:id])
    # call gcal link here
    @task.update(due_at: params[:due_at])
    render nothing: true
  end

  def index
    puts "IN INDEX ACTION OF TASKS CONTROLLER"
    puts params
    render nothing: true
  end

  # not working because finding day of which it's not part of 
  def destroy
    #@week = Week.find(params[:week_id])
    puts params
    @task = Task.find(params[:id])
    @task.destroy
    respond_to do |format|
        format.html { redirect_to next_seven_days_user_path(current_user.id) }
        format.js # no block because we are rendering destroy.js.erb
    end
  end

  def remove_overdue
    puts params
    @task = Task.find(params[:id])
    puts "+++++++++++ in remove_overdue"
    @overdue = params[:task][:overdue]
    @task.update(overdue: @overdue)
    respond_to do |format|
        format.html { redirect_to next_seven_days_user_path(current_user.id) }
        format.js # no block because we are rendering destroy.js.erb
    end
  end


  def show
    puts "IN SHOW ACTION TASKS"
  end

  # toggles important attribute
  def important
    @task = Task.find(params[:id])
    @day = Day.find(params[:day_id])
    @task.update(params[:task].permit(:important))
    respond_to do |format|
        format.html { redirect_to next_seven_days_user_path(current_user.id) }
        format.js # no block because we are rendering destroy.js.erb
    end
  end

  # toggles email attribute
  def email
    @task = Task.find(params[:id])
    @task.update(params[:task].permit(:email))
    respond_to do |format|
        format.html { redirect_to next_seven_days_user_path(current_user.id) }
        format.js # no block because we are rendering destroy.js.erb
    end
  end

  def update
    #@day = Day.find(params[:new_day_id][0])
    puts params
    @task = Task.find(params[:id])
    puts "+++++++++++ in update"
    puts params
    @task.update(day_id: params[:new_day_id][0])
    #basically rendering nothing so we don't need to redirect
    render json: {}
  end

  def complete
    @task = Task.find(params[:id])
    @task.update(params.permit(:complete))
    puts "FINISHING COMPLETE AND REDIRECTING"
    render nothing: true
    #redirect_to next_seven_days_user_path(current_user.id)
  end

  def update_ordering
    puts "+++++++++++ in update_ordering"
    puts params
    counter = 1
    params[:new_id].each do |id|
      Task.find(id).update(ordering: counter);
      counter += 1
    end
    render json: {}
  end

  private
  def task_params
    params[:task].permit(:description, :important, :day_id, :due_at, :ordering)
  end
end
