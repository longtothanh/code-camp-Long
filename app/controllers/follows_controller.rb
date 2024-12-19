class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])

    unless current_user.following?(@user)
      current_user.follow(@user)

      Notification.create!(
        user: current_user,
        notifiable: @user,
        action_type: 'follow'
      )

      follow_notification = { user: current_user.email, action: 'follow' }
      ActionCable.server.broadcast("user_#{current_user.id}_channel", follow_notification)

      redirect_to users_path, alert: "You are now following #{@user.email}."
    else
      redirect_to users_path, alert: "You are already following #{@user.email}."
    end
  end

  def destroy
    @user = User.find(params[:user_id])

    if current_user.following?(@user)
      current_user.unfollow(@user)

      Notification.create!(
        user: current_user,
        notifiable: @user,
        action_type: 'unfollow'
      )

      unfollow_notification = { user: current_user.email, action: 'unfollow' }
      ActionCable.server.broadcast("user_#{current_user.id}_channel", unfollow_notification)

      redirect_to users_path, notice: "You have unfollowed #{@user.email} successfully."
    else
      redirect_to users_path, notice: "You unfollow #{@user.email} successfully."
    end
  end
end
