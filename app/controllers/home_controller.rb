class HomeController < ApplicationController
  def index
    if user_signed_in?
      # 如果用户已登录，将其重定向到其他页面
    else
      # 如果用户未登录，将其重定向到登录页面
      redirect_to new_user_session_path
    end
  end
end
