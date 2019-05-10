#!/usr/bin/ruby
# Piet Lipke
# 2019
# Telegram FB5 Bot.

require_relative 'bot_handler.rb'
require_relative 'database_handler.rb'
require_relative 'feed_publisher.rb'


# TODO, Implement a subscribe to all method.
# Add chat_id to every table in database to do that.
# TODO, write exception for TCP/IP Timeout.
# When the bot looses its internet connection, let the code sleep for a minute or two.

# Constant is only used for comparison methods.
ALL_FEED = 'https://www.th-owl.de/fb5/fb5.rss'.freeze
TOKEN = '820968652:AAGtkxxNAr-Vvjz2l-292KHGBkj-QOmvmAc'.freeze

# Main class for the FB5RSS bot.
class FB5RSSBot
  def initialize
    @bot_handler = BotHandler.new
    @feed_publisher = FeedPublisher.new
    @database_handler = DatabaseHandler.new
    @db = SQLite3::Database.open 'users.db'
    @database_handler.create_tables(@db)
    Thread.new(&method(:publish_updates))
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
    @bot_handler.handle_commands(message, @bot)
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