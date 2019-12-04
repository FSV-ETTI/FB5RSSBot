# Piet Lipke
# 2019

#------------------------------------------------------------------------#
require 'sqlite3'
#------------------------------------------------------------------------#

class DatabaseHandler
  def initialize
    unless File.file?('users.db')
      SQLite3::Database.new('users.db')
    end
  end

  def create_tables(db)
    db.execute "CREATE TABLE IF NOT EXISTS Users (user INT)"
    db.execute "CREATE TABLE IF NOT EXISTS Messages (message INT)"
  end

  def db_delete_user(table, message, db)
    chat_id = message.chat.id
    db.execute "DELETE FROM Users WHERE user=#{chat_id}"
  end

  def db_insert_user(table, message, db)
    chat_id = message.chat.id
    db.execute "INSERT INTO Users VALUES(#{chat_id})"
  end

  def db_delete_blocked_user(chat_id, db)
    db.execute "DELETE FROM Users WHERE user=#{chat_id}"
  end

  def user_known(message, db)
    var = "SELECT * FROM Users"
    stm = db.prepare var
    rs = stm.execute
    rs.each do |existing_user|
      existing_user = to_str(existing_user.to_s)
      return true if existing_user == message.chat.id.to_s
    end
  end

  def to_str(string)
    length = string.length
    string[1..length - 2]
  end
end
