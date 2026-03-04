class TasksController < ApplicationController
    before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    # 判斷點擊了哪個排序連結，如果沒點，預設用建立時間排序
    if params[:sort] == "end_at"
      @tasks = Task.order(end_at: :asc)
    else
      @tasks = Task.order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @task = Task.new(start_at: Time.zone.now)
    @task.end_at = @task.start_at + 1.hour
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t("tasks.flash.create") # Flash 訊息
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t("tasks.flash.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t("tasks.flash.delete")
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    # 允許 Migration 定義過的欄位
    params.require(:task).permit(:title, :content, :start_at, :end_at, :priority, :status)
  end
end
