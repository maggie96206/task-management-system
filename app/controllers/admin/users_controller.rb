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
      redirect_to admin_users_path, notice: t(:create, scope: s)
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
  end

  def update
    if @user.update(user_params)
      @user.update_attribute(:admin, params[:user][:admin])
      redirect_to admin_users_path, notice: t(:update, scope: s)
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: t(:do_not_delete_yourself, scope: s)
    else
      @user.destroy
      redirect_to admin_users_path, notice: t(:delete, scope: s)
    end
  end


  private

  def s
    %i[admin users flash]
  end

  def check_admin
    redirect_to root_path, alert: t(:no_right, scope: s) unless current_user&.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
