class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_params_exist, only: :create
  def create
    user = User.new user_params
    if user.save
      render_response "Signed Up Successfully", true, {user: user}, :ok
    else
      render_response "Something Went Wrong", false, {}, :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def ensure_params_exist
    return if params[:user].present?
    render_response "Missing Params", false, {}, :bad_request
  end

end
