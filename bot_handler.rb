#!/usr/bin/ruby
# Piet Lipke
# 2019

require 'telegram/bot'
require_relative 'string_collection.rb'
require_relative 'rss_reader.rb'
require_relative 'utilities.rb'

# Contains the messaging methods.
class BotHandler
  def initialize
    @string_collection = StringCollection.new
    @rss_reader = RSSReader.new
    @utilities = Utilities.new
  end

  # Handle strings which are not found in keyboard. One can easily add more
  # commands here.
  def handle_commands(message, bot)
    case message.text
    when '/start'
      open_keyboard(bot, message)
    when '/stop'
      close_keyboard(bot, message)
    else
      NIL # NIL is deprecated.
    end
  end

  # Confirmation message.
  def unsubscribed_message(message, bot, db)
    return unless @string_collection.keyboard_strings.include? @utilities.reduce_message(message.text)

    infomonitore = update_keyboard(message, db)
    message_text = @utilities.reduce_message(message.text)
    bot.api.send_message(
      chat_id: message.chat.id,
      text: "Das Abonnement für den Feed #{message_text} wurde erfolgreich beendet.",
      reply_markup: infomonitore
    )
  end

  # Confirmation message.
  def subscribed_message(message, bot, db)
    return unless @string_collection.keyboard_strings.include? @utilities.reduce_message(message.text)

    message_text = @utilities.reduce_message(message.text)
    infomonitore = update_keyboard(message, db)
    bot.api.send_message(
      chat_id: message.chat.id,
      text: "#{message_text} feed wurde erfolgreich abonniert",
      reply_markup: infomonitore
    )
  end

  # push the latest message title of a monitor to a user.
  def title_message(chat_id, url, bot)
    chat_id = @utilities.to_str(chat_id)
    return if chat_id.nil?

    bot.api.send_message(chat_id: chat_id, text: 'Lade Feed..')
    bot.api.send_message(chat_id: chat_id, text: @rss_reader.read_title(url))
  end

  # push the latest message item of a monitor to a user.
  def item_message(chat_id, url, bot)
    chat_id = @utilities.to_str(chat_id)
    return if chat_id.nil?

    bot.api.send_message(
      chat_id: chat_id, text: @rss_reader.read_item_date(url) +
      "\n" + @rss_reader.read_item_title(url) +
      "\n" + @rss_reader.read_item_description(url)
    )
  end

  # Start the keyboard for a user.
  def open_keyboard(bot, message)
    text = 'Bitte wählen sie einen Infomonitor.'
    infomonitore = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: @string_collection.keyboard_strings
    )
    bot.api.send_message(
      chat_id: message.chat.id, text: text, reply_markup: infomonitore
    )
  end

  # Close the keyboard.
  def close_keyboard(bot, message)
    infomonitore = Telegram::Bot::Types::ReplyKeyboardRemove.new(
      remove_keyboard: true
    )
    bot.api.send_message(
      chat_id: message.chat.id, text: 'Tüdelü', reply_markup: infomonitore
    )
  end

  # Returns a new markup version of the keyboard with updated buttons.
  def update_keyboard(message, db)
    keyboard_strings = @string_collection.keyboard_strings
    keyboard_strings.each_with_index do |monitor, index|
      if subscribed?(monitor, message, db)
        keyboard_strings[index] = keyboard_strings[index] + ' | Abonniert'
      end
    end
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: keyboard_strings
    )
  end

  # Check if a user is already subscribed to a feed. Differs slightly from user_known method.
  # Maybe combine the two at a later point.
  def subscribed?(monitor, message, db)
    index_key = @string_collection.keyboard_strings.index(monitor)
    var = "SELECT * FROM #{@string_collection.keys[index_key]}"
    stm = db.prepare var
    rs = stm.execute
    rs.each do |existing_user|
      existing_user = @utilities.to_str(existing_user.to_s)
      return true if existing_user == message.chat.id.to_s
    end
  end
end
