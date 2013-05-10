Quo.Gesture.Core.addGesture do ($$ = Quo) ->

  TAP_MAX_TIME = 350
  DOUBLE_TAP_MAX_TIME = 350
  timeout = undefined
  lastEnd = undefined

  start: (gestureData) ->
    Quo.Gesture.Core.trigger "touchy"
    timeout = setTimeout (-> Quo.Gesture.Core.trigger "hold"), (TAP_MAX_TIME + 1)

  move: (gestureData) -> clearTimeout timeout

  end: (gestureData) ->
    clearTimeout timeout
    if lastEnd and new Date() - lastEnd < DOUBLE_TAP_MAX_TIME
      Quo.Gesture.Core.trigger "doubleTap"
      lastEnd = undefined
    else if gestureData.deltaTime < TAP_MAX_TIME
      Quo.Gesture.Core.trigger "tap"
      lastEnd = new Date()

  events: ["touchy", "tap", "doubleTap", "hold"]
