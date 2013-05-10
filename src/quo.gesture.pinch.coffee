Quo.Gesture.Core.addGesture do ($$ = Quo) ->

  ERROR_MARGIN = 10
  startDistance = 0
  triggered = false

  _trigger = (event) ->
    $$.Gesture.Core.trigger event
    triggered = true

  _distance = (positions) ->
    A = positions[0]
    B = positions[1]
    Math.sqrt((B.x-A.x)*(B.x-A.x)+(B.y-A.y)*(B.y-A.y))

  _checkEnd = (value, events) ->
    if value > ERROR_MARGIN then _trigger events[0]
    else if value < -ERROR_MARGIN then _trigger events[1]

  start = (gestureData) ->
    if gestureData.start.positions.length == 2
      startDistance = _distance gestureData.start.positions

  move = (gestureData) ->
    if gestureData.last.positions.length == 2
      if triggered then _trigger "pinching"
      else if Math.abs(_distance(gestureData.last.positions) - startDistance) > ERROR_MARGIN
        triggered = true

  end = (gestureData) ->
    if gestureData.last?.positions.length == 2
      if triggered then _trigger "pinch"
      _checkEnd _distance(gestureData.last.positions) - startDistance, ["pinchOut", "pinchIn"]
      triggered = false

  events: ["pinch", "pinching", "pinchIn", "pinchOut"]
  start: start
  move: move
  end: end
