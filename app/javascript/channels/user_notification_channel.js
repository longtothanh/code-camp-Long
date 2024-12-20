import consumer from "channels/consumer"

consumer.subscriptions.create("UserNotificationChannel", {
  connected() {
    console.log("đã kết nối");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const notifications = $("#notification_list")
    if (data.action_type == "follow" || data.action_type == "unfollow")
      notifications.append(`<tr><td>${data.email} has ${data.action_type}ed you</td><td class="time_table">${data.created_at}</td></tr>`);
    else
      notifications.append(`<tr><td>${data.email} has ${data.action_type} book</td><td class="time_table">${data.created_at}</td></tr>`);
  }
});
