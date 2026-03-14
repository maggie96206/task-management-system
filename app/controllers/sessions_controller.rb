class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create ]
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: t("sessions.log_in_success")
    else
      flash.now[:alert] = t("sessions.log_in_fail")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: t("sessions.logged_out"), status: :see_other
  end
end
