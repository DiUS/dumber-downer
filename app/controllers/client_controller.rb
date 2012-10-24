class ClientController < ApplicationController
  def index
    @home_timeline = Twitter.home_timeline
  rescue Twitter::Error::TooManyRequests => error
    raise "Rate limited. Try again in #{error.rate_limit.reset_in} seconds."
  end

  private

  def twitter_client
    @twitter_client ||= Twitter::Client.new(
      :oauth_token => ENV['TWITTER_OAUTH_TOKEN'],
      :oauth_token_secret => ENV['TWITTER_OAUTH_TOKEN_SECRET']
    )
  end

end
