Quo.Gesture = Quo.Gesture or {}
Quo.Gesture.Core = do ($$ = Quo) ->

  GESTURE_HANDLERS = []

  originalEvents = {}
  gesture = {}

  addGesture = (handler) ->
    GESTURE_HANDLERS.push handler
    for event in handler.events
      $$.fn[event] = (callback) ->
        $$(document.body).delegate @selector, event, callback

  onTouchStart = (event) ->
    originalEvents.start = event
    setGesture "start", event
    gesture.element = $$.Gesture.Capturer.getTarget event
    handler.start?(gesture) for handler in GESTURE_HANDLERS

  onTouchMove = (event) ->
    event.preventDefault()
    originalEvents.move = event
    if gesture.start
      setGesture "last", event
      handler.move?(gesture) for handler in GESTURE_HANDLERS

  onTouchEnd = (event) ->
    originalEvents.move = event
    if gesture.start
      setGesture "end", event
      for handler in GESTURE_HANDLERS
        handler.end?(gesture)
      do onTouchCancel

  onTouchCancel = (event) ->
    gesture = {}
    originalEvents = {}

  trigger = (eventName) ->
    params = params or {}
    gesture.element.trigger eventName, params, originalEvents

  # _getVendorTarget = (event) -> $$(event.target)


  #====== gesture setters ==================================================
  setGesture = (what, event) ->
    gesture[what] = {}
    setTimes what
    setPositions what, event

  setTimes = (what) ->
    gesture[what].time = new Date()
    gesture.deltaTime = new Date() - gesture.start.time unless what is "start"

  setPositions = (what, event) ->
    gesture[what].positions = $$.Gesture.Capturer.getFingersPositions event
    if what isnt "start" and gesture.last
      if gesture.start.positions.length == gesture.last.positions.length
        do setGestureDeltaPositions

  setGestureDeltaPositions = ->
    len = gesture.start.positions.length
    gesture.deltaPositions = []
    i = 0
    while i < len
      x = gesture.last.positions[i].x - gesture.start.positions[i].x
      y = gesture.last.positions[i].y - gesture.start.positions[i].y
      gesture.deltaPositions.push x: x, y: y
      i++

  $$(document).ready ->
    environment = $$ document.body
    environment.bind "touchstart", onTouchStart, true
    environment.bind "touchmove", onTouchMove, true
    environment.bind "touchend", onTouchEnd, true
    environment.bind "touchcancel", onTouchCancel, true


  trigger: trigger
  addGesture: addGesture


