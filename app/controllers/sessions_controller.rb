# class Users::SessionsController < Devise::SessionsController
#   def create
#     super do |resource|
#       remember_me = params[:user][:remember_me]
#       if remember_me == '1'
#         remember_me_for = 2.weeks
#         cookies.signed[:user_id] = { value: resource.id, expires: remember_me_for.from_now }
#         cookies.signed[:user_token] = { value: resource.authentication_token, expires: remember_me_for.from_now }
#       end
#     end
#   end
#
#   def destroy
#     super do
#       cookies.delete(:user_id)
#       cookies.delete(:user_token)
#       redirect_to root_path
#     end
#   end
# end
class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      remember_me = params[:user][:remember_me]
      if remember_me == '1'
        remember_me_for = 2.weeks
        cookies.signed[:user_id] = { value: resource.id, expires: remember_me_for.from_now }
        cookies.signed[:user_token] = { value: resource.authentication_token, expires: remember_me_for.from_now }
      end

      if resource.is_a?(Student)
        redirect_to students_root_path
      elsif resource.is_a?(Staff)
        redirect_to staff_root_path
      end
    end
  end

  def destroy
    super do
      cookies.delete(:user_id)
      cookies.delete(:user_token)
      redirect_to root_path
    end
  end
end
