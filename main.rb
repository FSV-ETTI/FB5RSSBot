# Piet Lipke
# 2019
# Telegram FB5 Bot.

require_relative 'bot_handler.rb'
require_relative 'database_handler.rb'
require_relative 'feed_publisher.rb'

# Constant is only used for comparison methods.
ALL_FEED = 'https://www.th-owl.de/fb5/fb5.rss'.freeze
ALL_FEED_KEY = 'AlleNachrichten'.freeze
TOKEN = '938873098:AAEaJ1ojhfG421ycrbKNNwgXVfVPDALCq6U'.freeze

# Main class for the FB5RSS bot.
class FB5RSSBot
  def initialize
    @message_trigger = false
    @bot_handler = BotHandler.new
    @feed_publisher = FeedPublisher.new
    @database_handler = DatabaseHandler.new
    @db = SQLite3::Database.open 'users.db'
    @database_handler.create_tables(@db)
    Thread.new(&method(:publish_updates))
    begin
      start_bot_connection
    rescue Faraday::ConnectionFailed
      retry
    end
  end

  def start_bot_connection
    Telegram::Bot::Client.run(TOKEN) do |bot|
      @bot = bot
      bot.listen(&method(:start_bot))
    end
  end

  # Start the bot.
  def start_bot(message)
    update_database(message)
    command_handler(message)
  end

  # Handle strings which are not in keyboard.
  def command_handler(message)
    @message_trigger = @bot_handler.handle_commands(message, @bot, @db, @message_trigger)
  end

  # Update the database.
  def update_database(message)
    @database_handler.db_update(message, @bot, @db)
  end

  # Publish the new message in feed to all users.
  def publish_updates
    @feed_publisher.distribute_update(@bot, @db)
  end
end

FB5RSSBot.new