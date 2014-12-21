# https://www.youtube.com/watch?v=S4UEv_jjPL0
# https://plus.googleapis.com/u/0/_/widget/render/comments?first_party_property=YOUTUBE&href=

# Keywords   all_happy_keywords   all_sad_keywords
# CommentThread    initialize(youtube_url)    populate [fill an array with Comment objects]   overall_sentiment
# Comment   overall_sentiment   count_happy_keywords   count_sad_keywords

require 'open-uri'
require 'nokogiri'
require 'htmlentities'


class Keywords
  attr_reader :happy, :sad
  def initialize
    @happy = ['love','loved','like','liked','awesome','amazing','good','great','excellent']
    @sad = ['hate','hated','dislike','disliked','awful','terrible','bad','painful','worst']
  end
end


class CommentThread
  def initialize youtube_url
    @all_comments = []
    @thread = Nokogiri::HTML(open "https://plus.googleapis.com/u/0/_/widget/render/comments?first_party_property=YOUTUBE&href=" + youtube_url)
  end

  def populate
    counter = 0
    @thread.css("div.Ct").each do |item|
      match = item.to_s.match(/<div class="Ct">(.+)<\/div>/)
      if match
        @all_comments << Comment.new(match) 
      end
      # @all_comments << HTMLEntities.new.decode(comment_text_with_nbsp_and_shit).force_encoding("ASCII")
    end
  end
end


class Comment
  def initialize text
    @text = text
    @keywords = Keywords.new
  end

  def count_happy_keywords
    counter = 0
    @keywords.happy.each do |keyword|
      count = @text.downcase.scan(Regexp.new(keyword)).count
      counter += count
    end
  end
end


c = Comment.new("i love love love it")
c.count_happy_keywords



# a = CommentThread.new "https://www.youtube.com/watch?v=S4UEv_jjPL0"
# a.populate

