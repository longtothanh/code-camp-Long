class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])

    unless current_user.following?(@user)
      current_user.follow(@user)
      redirect_to users_path, alert: "You are now following #{@user.email}."
    else
      redirect_to users_path, alert: "You are already following #{@user.email}."
    end
  end

  def destroy
    @user = User.find(params[:user_id])

    if current_user.following?(@user)
      current_user.unfollow(@user)
      redirect_to users_path, notice: "You have unfollowed #{@user.email} successfully."
    else
      redirect_to users_path, notice: "You unfollow #{@user.email} successfully."
    end
  end
end
