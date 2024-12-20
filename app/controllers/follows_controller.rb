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

      time = Notification.order(created_at: :desc).find_by(user_id: current_user.id)

      follow_notification = { email: current_user.email, action_type: 'follow', created_at: time.created_at.in_time_zone("Asia/Ho_Chi_Minh").to_formatted_s(:long) }
      UserNotificationChannel.broadcast_to(@user, follow_notification)

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

      time = Notification.order(created_at: :desc).find_by(user_id: current_user.id)

      unfollow_notification = { email: current_user.email, action_type: 'unfollow', created_at: time.created_at.in_time_zone("Asia/Ho_Chi_Minh").to_formatted_s(:long) }
      UserNotificationChannel.broadcast_to(@user, unfollow_notification)

      redirect_to users_path, notice: "You have unfollowed #{@user.email} successfully."
    else
      redirect_to users_path, notice: "You unfollow #{@user.email} successfully."
    end
  end
end
