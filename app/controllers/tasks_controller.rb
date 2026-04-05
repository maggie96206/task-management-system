class TasksController < ApplicationController
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!

  def index
    @pagy, @tasks = pagy(current_user.tasks.includes(:user)
                    .by_title(query_params[:title])
                    .by_status(query_params[:status])
                    .by_tag(query_params[:tag_id])
                    .sorted_by(query_params[:sort]))
  end


  def show
  end

  def new
    @task = Task.new(start_at: Time.zone.now)
    @task.end_at = @task.start_at + 1.hour
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to tasks_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t(".success")
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    # 允許 Migration 定義過的欄位
    params.require(:task).permit(:title, :content, :start_at, :end_at, :priority, :status, tag_ids: [], tags_attributes: [ :id, :name ])
  end

  def query_params
    params.permit(:sort, :title, :status, :tag_id)
  end
end
