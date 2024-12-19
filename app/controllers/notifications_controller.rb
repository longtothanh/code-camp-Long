class NotificationsController < ApplicationController
  def index
    # @notifications = current_user.notifications.includes(:notifiable).where(user: current_user).order(created_at: :desc)
    @notifications = Notification.all
  end
end
