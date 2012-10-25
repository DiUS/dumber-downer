#= require knockout
class @TimelinePage
  
  constructor: (timeline_js) ->
    @timeline = ko.mapping.fromJS(timeline_js)

  @initialize: (timeline_js) ->
    window.timelinePage = new TimelinePage(timeline_js)
    ko.applyBindings(window.timelinePage)
