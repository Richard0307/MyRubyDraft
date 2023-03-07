class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :update_headers_to_disable_caching
  # before_action :authenticate_staff, except: :index

  def user_signed_in?
    cookies.signed[:user_id].present?
  end

  def current_user
    @current_user ||= User.find_by(id: cookies.signed[:user_id])
  end

  def after_sign_in_path_for(resource)
    cookies.signed[:user_id] = resource.id
    if current_user.is_staff?
      staff_home_path
    else
      pages_home_path
    end
  end

  private

  def update_headers_to_disable_caching
    response.headers['Cache-Control'] = 'no-cache, no-store, private, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
    response.headers['Set-Cookie'] = 'HttpOnly; Secure; SameSite=Strict'
  end

  # def authenticate_staff
  #   redirect_to staff_home_path unless current_user&.is_staff?
  # end
end
