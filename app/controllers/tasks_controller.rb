class TasksController < ApplicationController
    before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    @tasks = Task.all # 從資料庫撈出所有任務，交給 View 顯示
  end

  def show
  end

  def new
    @task = Task.new(start_at: Time.current, end_at: Time.current + 1.hour)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t("tasks.flash.create") # Flash 訊息
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t("tasks.flash.update")
    else
      render :edit
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
