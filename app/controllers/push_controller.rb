class PushController < ApplicationController
#AK= AKIAJHQWLMQT2JNSSBVQ
#SK= fNRmxPbURLcYdAhRXJ8RNLgbfRQ476iclF3Wqm8w
# This is strictly used to send push notifications

  def self.push_message_to_user(message, user, type, id)
    self.push_message_to_users(message, [user], type, id)
  end

  def self.push_message_to_users(message, users, type, id)
    APNS.host = 'gateway.sandbox.push.apple.com'
    APNS.pem = "#{Rails.root}/ck.pem"
    APNS.port = 2195

    notifications = []
    users.each do |user|
      if !user.device_token.nil?
        user.update_attribute(:notification_count, (user.notification_count).to_i + 1)
        notification = APNS::Notification.new(user.device_token, :alert => message, :badge => user.notification_count, :other => {:type => type, :id => id})
        notifications << notification
      end
    end

    puts APNS.send_notifications(notifications)
  end

end
