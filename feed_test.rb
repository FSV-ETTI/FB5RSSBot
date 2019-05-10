#!/usr/bin/ruby
# Piet Lipke
# 2019

# This class is only used for testing purposes.
# The Normal feeds are replaced by a feed which pushes a new update every 1 second.
class StringCollection
  # Keyboard buttons.
  def keyboard_strings
    %w[
      Testing\ Monitor
    ]
  end

  # Array containing all RSS urls.
  def monitors
    %w[
      http://lorem-rss.herokuapp.com/feed?unit=second
    ]
  end

  # Array containing the keys for database.
  def keys
    %w[
      TestingMonitor
    ]
  end

  # Hash used to find the Key of the users database.
  # Assignment branch is pretty high if replaced by method references.
  def hash_monitors
    Hash[
        'http://lorem-rss.herokuapp.com/feed?unit=second' =>
            'TestingMonitor'
    ]
  end
end
