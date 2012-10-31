require 'htmlentities'

# Extends Twitter Gem's tweet class
Twitter::Tweet.class_eval do  
  include ActionView::Helpers::DateHelper

  alias :original_initialize :initialize 

  def initialize(attrs)
    original_initialize(attrs)

    time_ago
    retweeted_status
    decoded_text

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
      Twitter::Tweet.disambiguator.disambiguate(decoded_text_with_no_links)
    end
  end

  def decoded_text
    attrs[:decoded_text] ||= HTMLEntities.new.decode(text)
  end

  def decoded_text_with_no_links
    decoded_text.gsub(/\b(https?|ftp|file):\/\/[-A-Za-z0-9+&@#\/%?=~_|!:,.;]*[-A-Za-z0-9+&@#\/%=~_|]/, '')
  end

  def dumber
    enhanced_text[:dumber] ||= begin
      disambiguated.enhance(:shortest)
    end
  end

  def smarter
    enhanced_text[:smarter] ||= begin
      disambiguated.enhance(:longest)
    end
  end

  def self.disambiguator
    @disambiguator ||= Disambiguator.new(ENV['MASHAPE_PUBLIC_KEY'], ENV['MASHAPE_PRIVATE_KEY'], "https://springsense.p.mashape.com/disambiguate")
  end
end

DisambiguatedResult.class_eval do
  def enhance(type = :shortest)
    sentences.map do | sentence |
      sentence.variants.first.map do | resolved_term | 
        (resolved_term.has_meaning? and !resolved_term.is_type?) ? (type == :shortest ? resolved_term.shortest_alternative : resolved_term.longest_alternative) : resolved_term.to_s
      end.join(" ")
    end.join(". ")
  end
end

ResolvedTerm.class_eval do

  def self.lexicon 
    @lexicon ||= WordNet::Lexicon.new
  end

  def meaning_token
    has_meaning? ? meaning.split(/_n_/)[0] : nil
  end

  def meaning_index
    has_meaning? ? meaning.split(/_n_/)[1].to_i : nil
  end

  def synsets
    @synsets ||= ResolvedTerm.lexicon.lookup_synsets(meaning_token, :noun, meaning_index)
  end

  def words
    ( synsets.try(:first).try(:words) || [] ) + [ word ]
  end

  def shortest_alternative
    words.sort do | x, y |
      x.to_s.length <=> y.to_s.length
    end.first.to_s.gsub(/_/, ' ')
  end

  def longest_alternative
    words.sort do | x, y |
      y.to_s.length <=> x.to_s.length
    end.first.to_s.gsub(/_/, ' ')
  end

end