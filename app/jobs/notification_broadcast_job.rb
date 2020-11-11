class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(item)
    ActionCable.server.broadcast "notify", {
      data: item
    }
  end
end
