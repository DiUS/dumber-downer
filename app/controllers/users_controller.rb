class UsersController < ApplicationController

  def show
    @id = params[:id]
    @user = Twitter.user(@id)
    @timeline = Twitter.user_timeline(@id)
  rescue Twitter::Error::TooManyRequests => error
    raise "Rate limited. Try again in #{error.rate_limit.reset_in} seconds."
  end

end
