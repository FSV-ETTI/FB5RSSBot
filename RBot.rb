# Piet Lipke
# 2019
# Telegram FB5 Bot.

#------------------------------------------------------------------------#
require_relative 'BotHandler.rb'
require_relative 'FeedDaemon'
require_relative 'DatabaseHandler'
#------------------------------------------------------------------------#

# Constants                                                              #
##########################################################################
ADMIN = 10915579.freeze
FEED = 'http://lorem-rss.herokuapp.com/feed?unit=second'.freeze
TOKEN = '938873098:AAEaJ1ojhfG421ycrbKNNwgXVfVPDALCq6U'.freeze
##########################################################################
#                                                                        #

# Main class for the FB5RSS bot.
class RBot
  def initialize
    @bot_handler = BotHandler.new
    @feed_daemon = FeedDaemon.new
    @database_handler = DatabaseHandler.new

    @db = SQLite3::Database.open 'users.db'
    @database_handler.create_tables(@db)

    Thread.new(&method(:publish_updates))

    begin
      Telegram::Bot::Client.run(TOKEN) do |bot|
        @bot = bot
        bot.listen(&method(:start_bot))
      end
    rescue Faraday::ConnectionFailed
      retry
    end
  end

  def start_bot(message)
    command_handler(message)
  end

  def command_handler(message)
    @bot_handler.handle_commands(message, @bot, @db)
  end

  def publish_updates
    @feed_daemon.distribute_update(@bot, @db)
  end
end

RBot.new
