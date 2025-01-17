class Api::V1::SessionsController < Devise::SessionsController
  before_action :load_user, only: :create
  before_action :load_user, only: :create
  before_action :valid_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      render_response "Signed In Successfully", true, { user: @user }, :ok
    else
      render_response "Unauthorized", false, {}, :unauthorized
    end
  end

  def destroy
    sign_out @user
    @user.generate_new_authentication_token
    render_response "Log out Successfully", true, {}, :ok
  end

  private
  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end
  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user
      return @user
    else
      render_response "Can not get user", false, {}, :bad_request
    end
  end
  def valid_token
    @user = User.find_by authentication_token: request.headers["AUTHENTICATION-TOKEN"]
    if @user
      return @user
    else
      render_response "Invalid Token", false, {}, :bad_request
    end
  end
end
