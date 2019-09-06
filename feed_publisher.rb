# Piet Lipke
# 2019

require_relative 'utilities.rb'
require_relative 'rss_reader.rb'
require_relative 'bot_handler.rb'
require_relative 'database_handler.rb'
require_relative 'string_collection.rb'

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
      next if url == @string_collection.monitors[0]
      return url if date == @rss_reader.read_item_date(url)
    end
    return @string_collection.monitors[0]
  end

  # Checks if a new message is in feed. if it is, call publish method.
  def distribute_update(bot, db)
    last_date = @rss_reader.read_item_date(ALL_FEED)
    loop do
      begin
        if @rss_reader.compare_dates(ALL_FEED, last_date)
          # url_update is used to find the url in which the last message was posted
          url_update = find_monitor(last_date)
          publish_new_update(url_update, bot, db)
          last_date = @rss_reader.read_item_date(ALL_FEED)
        end
        sleep(5)
      rescue SocketError
        sleep(5)
        puts "rescued! SocketError"
        next
      rescue Net::OpenTimeout
        puts "rescued! OpenTimeout"
        sleep(5)
        next
      rescue Errno::ECONNRESET
        puts "rescued! ECONNRESET"
        sleep(5)
        next
      end
    end
  end

  # Publishes the new message in Feed.
  def publish_new_update(url, bot, db)
    key = @utilities.translate_url(url)
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

    var = "SELECT * FROM #{@string_collection.keys[0]}"
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
