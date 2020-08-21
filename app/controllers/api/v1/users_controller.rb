class Api::V1::UsersController < ApplicationController

  def facebook
    if params[:facebook_access_token]
      graph = Koala::Facebook::API.new params[:facebook_access_token]
      user_data = graph.graph_call("me?fields=id,name,email,picture")
      user = User.find_by email: user_data["email"]
      if user
        user.generate_new_authentication_token
        render_response "user Information", true, {user: user}, :ok
      else
        user = User.new(
          email: user_data["email"],
          uid: user_data["id"],
          provider: "facebook",
          image: user_data["picture"]["data"]["url"],
          password: Devise.friendly_token[0,20])

        user.authentication_token = User.generate_unique_secure_token

        if user.save
          render_response "Login Facebook Successfully", true, {user: user}, :ok
        else
          render_response user.errors, false, {}, :unprocessable_entity
        end
      end
    else
      render_response "Missing Facebook Access Token", false, {}, :unprocessable_entity
    end
  end
end
