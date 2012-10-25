class UsersController < ApplicationController

  def show
    @id = params[:id]
    @user = Twitter.user(@id)
    @timeline = Twitter.user_timeline(@id)

    tweet = @timeline.first
    json = tweet.to_json
    parsed_json = MultiJson.load(json, symbolize_keys: true)
    #tweet = Twitter::Tweet.from_response(id: tweet.id, body: JSON.parse(json))
    tweet = Twitter::Tweet.new(parsed_json)
    puts tweet.to_yaml
  rescue Twitter::Error::TooManyRequests => error
    raise "Rate limited. Try again in #{error.rate_limit.reset_in} seconds."
  end

end
