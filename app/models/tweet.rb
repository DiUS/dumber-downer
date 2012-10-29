# Extends Twitter Gem's tweet class
Twitter::Tweet.class_eval do  
  include ActionView::Helpers::DateHelper

  alias :original_initialize :initialize 

  def initialize(attrs)
    original_initialize(attrs)

    time_ago
    retweeted_status

    attrs[:enhanced_text] = { :dumber => "", :smarter => "" }

    self
  end

  def time_ago
    attrs[:time_ago] ||= time_ago_in_words(self.created_at)
  end
  
  def enhanced_text
    attrs[:enhanced_text]
  end

  def disambiguated
    enhanced_text[:disambiguated] ||= begin 
      Twitter::Tweet.disambiguator.disambiguate(text)
    end
  end

  def dumber
    enhanced_text[:dumber] ||= begin
      disambiguated.text_variants_in_rank_order.first
    end
  end

  def smarter
    enhanced_text[:smarter] ||= begin
      disambiguated.text_variants_in_rank_order.first
    end
  end

  def self.disambiguator
    @disambiguator ||= Disambiguator.new(ENV['MASHAPE_PUBLIC_KEY'], ENV['MASHAPE_PRIVATE_KEY'], "https://springsense.p.mashape.com/disambiguate")
  end
end
