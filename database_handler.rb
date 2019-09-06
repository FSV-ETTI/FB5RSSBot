# Piet Lipke
# 2019

require 'sqlite3'
require_relative 'utilities.rb'
require_relative 'bot_handler.rb'
require_relative 'string_collection.rb'

# Handles basic database actions.
class DatabaseHandler
  # Create the database, if it doesn't exists.
  def initialize
    @utilities = Utilities.new
    @bot_handler = BotHandler.new
    @string_collection = StringCollection.new
    unless File.file?('users.db')
      SQLite3::Database.new('users.db')
    end
  end

  # Create tables in database.
  def create_tables(db)
    @string_collection.keys.each do |key|
      db.execute "CREATE TABLE IF NOT EXISTS #{key}(user INT)"
    end
  end

  # Update the database if a new user subscribed or unsubscribed.
  def db_update(message, bot, db)
    message_text = @utilities.reduce_message(message.text)
    return unless @string_collection.keyboard_strings.include? message_text

    index_message = @string_collection.keyboard_strings.index(message_text)
    user_exists = user_known(message, db)
    if user_exists
      db_delete_user(@string_collection.keys[index_message], message, db)
      @bot_handler.unsubscribed_message(message, bot, db)
    else
      if index_message == 0
        db_delete_users(message, db)
        db_insert_user(@string_collection.keys[0], message, db)
        @bot_handler.subscribed_message(message, bot, db, false)
      else
        db_insert_user(@string_collection.keys[index_message], message, db)
        @bot_handler.subscribed_message(message, bot, db)
      end
    end
  end

  # Something
  def db_delete_users(message, db)
    chat_id = message.chat.id
    for key in 1..17 do
      table = @string_collection.keys[key]
      db.execute "DELETE FROM #{table} WHERE user=#{chat_id}"
    end
  end

  # Method to delete a chat id in database.
  def db_delete_user(table, message, db)
    chat_id = message.chat.id
    db.execute "DELETE FROM #{table} WHERE user=#{chat_id}"
  end

  # Method to insert a new user in the database.
  def db_insert_user(table, message, db)
    chat_id = message.chat.id
    db.execute "INSERT INTO #{table} VALUES(#{chat_id})"
  end

  # Delete a user from Database if the user blocked the Bot.
  def db_delete_blocked_user(chat_id, db)
    @string_collection.keys.each do |table|
      db.execute "DELETE FROM #{table} WHERE user=#{chat_id}"
    end
  end

  # Check if a chat id is already in database.
  def user_known(message, db)
    index_key = @string_collection.keyboard_strings.index(@utilities.reduce_message(message.text))
    var = "SELECT * FROM #{@string_collection.keys[index_key]}"
    stm = db.prepare var
    rs = stm.execute
    rs.each do |existing_user|
      existing_user = @utilities.to_str(existing_user.to_s)
      return true if existing_user == message.chat.id.to_s
    end
  end
end
