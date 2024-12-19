import consumer from "channels/consumer"

consumer.subscriptions.create("UserNotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    alert(`${data.user} has ${data.action}ed you.`);
  }
});
