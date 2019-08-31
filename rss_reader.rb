# Piet Lipke
# 2019

require 'rss'
require 'open-uri'

# Methods to read the FB5 RSS-Feed.
class RSSReader
  # Returns the title of the selected monitor.
  def read_title(url)
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.channel.title
    end
  end

  # Returns the title of the last message in feed.
  def read_item_title(url)
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.first.title
    end
  end

  # Returns the description of the last message in feed.
  def read_item_description(url)
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.first.description
    end
  end

  # Compare the dates of the last published message and the last one in feed.
  def compare_dates(url, last_date)
    true if read_item_date(url) != last_date
  end

  # Returns the date of the last entry in feed.
  def read_item_date(url)
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.channel.lastBuildDate.to_s
    end
  end
end
