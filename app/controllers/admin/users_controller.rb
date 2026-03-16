class Admin::UsersController < ApplicationController
  before_action :check_admin
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @pagy, @users = pagy(User.includes(:tasks).all)
  end

  def show
    @pagy, @tasks = pagy(@user.tasks.order(created_at: :desc))
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "成功新增使用者"
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
  end

  def update
      # 如果密碼欄位是空的，就從 params 中移除，避免驗證失敗
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      if @user.update(user_params)
        redirect_to admin_users_path, notice: "使用者資料更新成功"
      else
        render :edit, status: :unprocessable_entity
      end
  end


  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "不能刪除自己！"
    else
      @user.destroy
      redirect_to admin_users_path, notice: "使用者及其任務已刪除"
    end
  end


  private

  def check_admin
    redirect_to root_path, alert: "您沒有管理權限！" unless current_user&.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :admin)
  end
end
