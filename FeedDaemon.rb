# Piet Lipke
# 2019

#------------------------------------------------------------------------#
require_relative 'RSSReader.rb'
require_relative 'BotHandler'
require_relative 'DatabaseHandler'
#------------------------------------------------------------------------#

class FeedDaemon
  def initialize
    @rss_reader = RSSReader.new
    @bot_handler = BotHandler.new
    @database_handler = DatabaseHandler.new
  end

  def distribute_update(bot, db)
    @last_date = @rss_reader.read_item_date

    loop do
      begin
        if @rss_reader.compare_dates(@last_date)
          publish_message(bot, db)
          @last_date = @rss_reader.read_item_date
        end
      rescue SocketError
        sleep(1)
        puts "rescued! SocketError"
        retry
      rescue Net::OpenTimeout
        puts "rescued! OpenTimeout"
        sleep(1)
        retry
      rescue Errno::ECONNRESET
        puts "rescued! ECONNRESET"
        sleep(1)
        retry
      rescue OpenURI::HTTPError
        puts "rescued! HTTPError"
        sleep(1)
        retry
      end
    end
  end

  def publish_message(bot, db)
    var = "SELECT * FROM Users"
    stm = db.prepare var
    rs = stm.execute

    rs.each do |chat_id|
      begin
        @bot_handler.item_message(chat_id.to_s, bot)
      rescue Telegram::Bot::Exceptions::ResponseError
        @database_handler.db_delete_blocked_user(to_str(chat_id.to_s), db)
        retry
      end
    end
  end

  def to_str(string)
    length = string.length
    string[1..length - 2]
  end
end

