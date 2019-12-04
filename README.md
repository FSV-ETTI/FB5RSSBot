# FB5 RSS Telegram Bot
Repositroy of FB5RSSTelegramBot by the Student Council of the Technical University OWL.

# Overview


This Bot is using the Ruby Telegram Bot API wrapper telegram-bot-ruby by atipugin and the SQLite ruby API.

Link to repo of wrapper: https://github.com/atipugin/telegram-bot-ruby

### Installation

To use the Bot you need to install two gems:

* telegram-bot-ruby

```$ gem install telegram-bot-ruby```

* SQLite 3

```$ gem install sqlite3```

# Commands

### /start

Registers the user.

### /stop

Deletes the user.

# Debugging

You might experience some issues when trying to install the sqlite3 ruby gem on Linux.
To fix these issues install the ruby-dev and build-essential packages.

```$ sudo apt-get install sqlite3 libsqlite3-dev```

```$ sudo apt-get install build-essential```

```$ sudo apt-get install ruby-dev```

```$ sudo gem install sqlite3```

