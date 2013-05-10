Quo.Gesture.Core.addGesture do ($$ = Quo) ->

  ERROR_MARGIN = 10
  triggered = false

  _trigger = (event) ->
    $$.Gesture.Core.trigger event
    triggered = true

  _checkEnd = (value, events) ->
    if _isSwipe(value, true) then _trigger events[0]
    else if _isSwipe(value, false) then _trigger events[1]

  _isSwipe = (value, plusDirection = true) ->
    if plusDirection then (value > ERROR_MARGIN) else (value < -ERROR_MARGIN)

  move = (gestureData) ->
    if gestureData.last.positions.length == 1
      if triggered then _trigger "swiping"
      else
        swipeX = Math.abs(gestureData.deltaPositions[0].x) > ERROR_MARGIN
        swipeY = Math.abs(gestureData.deltaPositions[0].y) > ERROR_MARGIN
        triggered = true if swipeX or swipeY

  end = (gestureData) ->
    if gestureData.last
      if triggered then _trigger "swipe"
      _checkEnd gestureData.deltaPositions[0].x, ["swipeRight", "swipeLeft"]
      _checkEnd gestureData.deltaPositions[0].y, ["swipeDown", "swipeUp"]
      triggered = false

  events: ["swipe", "swiping", "swipeLeft", "swipeRight", "swipeUp", "swipeDown"]
  move: move
  end: end
