class ApplicationController < ActionController::Base
  before_action :basic_auth if Rails.env.production?
  before_action :authenticate_user!

  allow_browser versions: :modern
  stale_when_importmap_changes

  include Pagy::Backend

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    redirect_to login_path, alert: t("sessions.please_log_in") unless logged_in?
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end
