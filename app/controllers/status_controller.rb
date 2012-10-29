class StatusController < ApplicationController

  def process(id)
    tweet_hash = params[:tweet]
    tweet_external = Twitter::Tweet.new(tweet_hash)

    if (tweet_external.retweeted_status) 
      tweet_external.retweeted_status.enhanced_text[:dumber] = nil
      tweet_external.retweeted_status.enhanced_text[:smarter] = nil
      tweet_external.retweeted_status.dumber
      tweet_external.retweeted_status.smarter
    else
      tweet_external.enhanced_text[:dumber] = nil
      tweet_external.enhanced_text[:smarter] = nil
      tweet_external.dumber
      tweet_external.smarter
    end

    json_s = tweet_external.to_json

    respond_to do | format |
      format.json {
        render :json => json_s
      }
    end

  end

end
