require 'open-uri'
require 'nokogiri'
require 'active_support/inflector'


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
        @all_comments << Comment.new(match.captures[0]) 
      end
    end
  end

  def overall_sentiment
    if total_happy_keywords > total_sad_keywords
      "happy"
    elsif total_sad_keywords > total_happy_keywords
      "sad"
    else
      "zen"
    end
  end

  def total_happy_keywords
    counter = 0
    @all_comments.each do |comment|
      counter += comment.count_happy_keywords
    end
    counter
  end

  def total_sad_keywords
    counter = 0
    @all_comments.each do |comment|
      counter += comment.count_sad_keywords
    end
    counter
  end

  def output_description
    puts "The first #{@all_comments.length} comments are mostly #{overall_sentiment}. They contained #{total_happy_keywords} #{"happy keyword".pluralize(total_happy_keywords)} and #{total_sad_keywords} #{"sad keyword".pluralize(total_sad_keywords)}."
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
    counter
  end

  def count_sad_keywords
    counter = 0
    @keywords.sad.each do |keyword|
      count = @text.downcase.scan(Regexp.new(keyword)).count
      counter += count
    end
    counter
  end

  def overall_sentiment
    if count_happy_keywords > count_sad_keywords
      "happy"
    elsif count_sad_keywords > count_happy_keywords
      "sad"
    end
  end
end

c = CommentThread.new "https://www.youtube.com/watch?v=S4UEv_jjPL0"
c.populate
c.output_description
