class UserNotificationChannel < ApplicationCable::Channel
  def subscribed
    # Lắng nghe thông báo chỉ dành cho người dùng hiện tại
    stream_for current_user
    # puts "Subscribed to #{current_user}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
