class Chat < ApplicationRecord
  belongs_to :user

  after_create_commit do
    broadcast_prepend_to "chats_index", partial: "chats/chat_row", target: "chat_rows"
  end
end
