# FB5 RSS Telegram Bot
Repositroy of FB5RSSTelegramBot by the Student Council of the Technical University OWL.

# Overview
This Bot uses the Ruby Telegram Bot API wrapper telegram-bot-ruby by atipugin and the SQLite ruby API.

Link to repo of wrapper: https://github.com/atipugin/telegram-bot-ruby

### Installation

To use the Bot you need to install two gems:

* telegram-bot-ruby

```$ gem install telegram-bot-ruby```

* SQLite 3

```$ gem install sqlite3```


# Implementation

The Bot is using two threads.

### Thread 1

The first thread is used to handle messages sent by the user and manages the SQL Database.
When a user sends a Message to subscribe or unsubscribe a feed, first an algorithm will check whether the user already exists in the Database or if he is not listed yet.
After the check the custom keyboard, which will be activated once a user uses the /start command, will be changed according to the current subscription status.

### Thread 2

In the second thread, every 10 seconds an algorithm will check if a new message was posted in the "Alle Nachrichten" feed. If a new message was posted, the message will be distributed to every user in the according SQL table.

Structure of SQL Database:
In the SQL Database a table will be created for every Feed in the StringCollection class.
The Keys are the Names of the RSS Feeds written in CamelCase. You can inspect the keys in the Keys method.

### Modifications

To change the RSS Feeds, you'll need to change the strings in the string_collection.rb class.
Additionally you'll need to change the constant ALL_FEED in main.rb which is used to check if a new message was posted in the feed.

```ALL_FEED = 'CUSTOM_URL'.freeze```


```
  def keyboard_strings
    %w[
      Strings which will be displayed on the custom keyboard.
    ]
  end
```

```
  def monitors
    %w[
      URL(s) of the monitor(s) the Bot checks for updates.
    ]
  end
```

```
  def keys
    %w[
      This Array is used to create the tables in the database and some comparisons.
      To add a monitor just add a string written in CamelCase here.
    ]
  end
```

# Commands

### /start

Applies the markup on the keyboard.

### /stop

Removes the custom keyboard.


