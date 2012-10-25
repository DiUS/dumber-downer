#= require knockout
class @TimelinePage
  
  constructor: (attributes) ->
    @user = ko.mapping.fromJS(attributes.user)
    @timeline = ko.mapping.fromJS(attributes.timeline)
    @title = ko.computed(
      () -> 
        if (@user)
          "DumberDowner"
        else
          "#{@user.name()} (@#{@user.screen_name()}) - DumberDowner"
      , this)

  @initialize: (timeline_js) ->
    window.timelinePage = new TimelinePage(timeline_js)
    ko.applyBindings(window.timelinePage, document.getElementById("htmlTop"))
