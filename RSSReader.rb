# Piet Lipke
# 2019

#------------------------------------------------------------------------#
require 'rss'
require 'open-uri'
#------------------------------------------------------------------------#

class RSSReader
  def read_title
    open(FEED) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.channel.title
    end
  end

  def read_item_description
    open(FEED) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.first.description
    end
  end

  def compare_dates(last_date)
    true if read_item_date != last_date
  end

  def read_item_date
    open(FEED) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.first.pubDate.to_s
    end
  end
end
