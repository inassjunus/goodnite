module Authorization
  extend ActiveSupport::Concern

  # check if user is admin
  def authorize_admin
    if !@current_user.admin?
      render json: { error: "Unauthorized" }, status: :unauthorized
      nil
    end
  end

  # check if user can access the resource
  def authorize_user
    if !@current_user.admin? && @current_user.id != @user.id
      render json: { error: "Unauthorized" }, status: :unauthorized
      nil
    end
  end
end
