# Piet Lipke
# 2019

# Some random methods for some random stuff.
class Utilities
  # Another string conversion. Only used when to_s was used. Fixes a ?Bug.
  def to_str(string)
    length = string.length
    string[1..length - 2]
  end

  # translate the url found by find_new_message to a key for the database.
  def translate_url(url)
    monitor_hash = StringCollection.new.hash_monitors
    monitor_hash[url]
  end

  # Reduce a message to its original form, without the pipe and "Abonniert"
  def reduce_message(message)
    return if message.nil?

    if message.include? '|'
      pipe_index = message.index('|')
      message[0..pipe_index-2]
    else
      message
    end
  end
end
