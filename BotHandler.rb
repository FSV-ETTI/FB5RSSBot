# Piet Lipke
# 2019

#------------------------------------------------------------------------#
require 'telegram/bot'
require_relative 'RSSReader.rb'
#------------------------------------------------------------------------#

class BotHandler
  def initialize
    @rss_reader = RSSReader.new
  end

  def handle_commands(message, bot, db)
    case message.text
    when '/start'
      register_user(message, bot, db)
    when '/stop'
      delete_user(message, bot, db)
    when /\/Message/
      return unless is_admin?(message, bot, db)

      publish_message(message, bot, db)
    else
      nil
    end
  end

  def register_user(message, bot, db)
    chat_id = message.chat.id

    db.execute "INSERT INTO Users VALUES(#{chat_id})"
  end

  def delete_user(message, bot, db)
    chat_id = message.chat.id

    db.execute "DELETE FROM Users WHERE user=#{chat_id}"
  end

  def is_admin?(message, bot, db)
    return if message.chat.id != ADMIN

    true
  end

  def publish_message(message, bot, db)
    text = message.text[12..-1]
    return unless text.is_a? String

    user_list = users(db)

    user_list.each do |user|
      bot.api.send_message(
        chat_id: user, text: text
      )
    end
  end

###################################################################

###################################################################

  def title_message(chat_id, bot)
    chat_id = to_str(chat_id)

    return if chat_id.nil?

    bot.api.send_message(chat_id: chat_id,
                         text: @rss_reader.read_title
    )
  end

  def item_message(chat_id, bot)
    chat_id = to_str(chat_id)
    return if chat_id.nil?

    bot.api.send_message(
      chat_id: chat_id, text: @rss_reader.read_item_description
    )
  end

  def users(db)
    chat_ids = []
    var = "SELECT * FROM Users"
    stm = db.prepare var
    rs = stm.execute
    rs.each do |existing_user|
      chat_ids << existing_user[0]
    end
    chat_ids = chat_ids.uniq
  end

  def to_str(string)
    length = string.length
    string[1..length - 2]
  end
end
