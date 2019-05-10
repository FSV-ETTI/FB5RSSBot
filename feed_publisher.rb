#!/usr/bin/ruby
# Piet Lipke
# 2019

require_relative 'string_collection.rb'
require_relative 'bot_handler.rb'
require_relative 'rss_reader.rb'
require_relative 'utilities.rb'
require_relative 'database_handler.rb'

# Handles the sending message process if a new message is in RSS-Feed.
class FeedPublisher
  def initialize
    @string_collection = StringCollection.new
    @bot_handler = BotHandler.new
    @rss_reader = RSSReader.new
    @utilities = Utilities.new
    @database_handler = DatabaseHandler.new
  end

  # Returns the URL in which a new message was found.
  def find_monitor(date)
    urls = @string_collection.monitors
    urls.each do |url|
      return url if date == @rss_reader.read_item_date(url)
    end
  end

  # Checks if a new message is in feed. if it is, call publish method.
  def distribute_update(bot, db)
    last_date = 0
    loop do
      if @rss_reader.compare_dates(ALL_FEED, last_date)
        last_date = @rss_reader.read_item_date(ALL_FEED)
        url_update = find_monitor(last_date)
        publish_new_update(url_update, bot, db)
      end
      sleep(10)
    end
  end

  # Publishes the new message in Feed.
  def publish_new_update(url, bot, db)
    key = @utilities.translate_url(url)
    return if key.nil?

    var = "SELECT * FROM #{key}"
    stm = db.prepare var
    rs = stm.execute
    rs.each do |chat_id|
      begin
        @bot_handler.title_message(chat_id.to_s, url, bot)
        @bot_handler.item_message(chat_id.to_s, url, bot)
      rescue Telegram::Bot::Exceptions::ResponseError
        @database_handler.db_delete_blocked_user(@utilities.to_str(chat_id.to_s), db)
        next
      end
    end
  end
end
