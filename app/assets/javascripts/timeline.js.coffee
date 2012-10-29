#= require knockout
class @TimelinePage
  
  constructor: (attributes) ->
    @user = ko.mapping.fromJS(attributes.user)
    @timeline = ko.mapping.fromJS(attributes.timeline);
    @title = ko.computed(
      () -> 
        if (@user)
          "DumberDowner"
        else
          "#{@user.name()} (@#{@user.screen_name()}) - DumberDowner"
      , this)
    console.log("Requesting processing for tweets")
    for tweet in @timeline()
      do (tweet) -> 
        console.log("Requesting processing for tweet", tweet)
        $.post("/status/#{tweet.id()}/process", { tweet: ko.toJS(tweet) }, (result_tweet) ->
          original_tweet = (tweet for tweet in window.timelinePage.timeline() when tweet.id().toString() == result_tweet.id.toString() )[0]

          ko.mapping.fromJS(result_tweet, {}, original_tweet)
        )

  @initialize: (timeline_js) ->
    window.timelinePage = new TimelinePage(timeline_js)
    ko.applyBindings(window.timelinePage, document.getElementById("htmlTop"))
