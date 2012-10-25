class StatusController < ApplicationController
  def process
    tweet_hash = params[:tweet]
    tweet_external = Twitter::Tweet.new(tweet_hash)

    render partial: 'client/tweet_external', locals: { tweet_external: tweet_external }
  end

end
