Quo.Gesture.Core.addGesture do ($$ = Quo) ->

  ERROR_MARGIN = 5
  startAngle = undefined
  lastDiff = undefined
  triggered = false

  _trigger = (event) ->
    $$.Gesture.Core.trigger event
    triggered = true

  _fixAngleDiff = (currentDiff) ->
    if lastDiff and Math.abs(currentDiff - lastDiff) > 20
      times = 0
      while Math.abs(currentDiff - lastDiff) > 50 and times++ < 10
        if lastDiff < 0 then currentDiff -= 180
        else currentDiff += 180
    currentDiff

  _angle = (positions) ->
    A = positions[0]
    B = positions[1]
    angle = Math.atan((B.y-A.y)*-1/(B.x-A.x))*(180/Math.PI)

  start = (gestureData) ->
    if gestureData.start.positions.length == 2
      startAngle = _angle gestureData.start.positions

  move = (gestureData) ->
    if gestureData.last.positions.length == 2
      currentAngle = _angle gestureData.last.positions
      lastDiff = _fixAngleDiff(startAngle - currentAngle)
      if triggered then _trigger "rotating"
      else if Math.abs(lastDiff) > ERROR_MARGIN then triggered = true

  end = (gestureData) ->
    if gestureData.last?.positions.length == 2
      if triggered then _trigger "rotate"
      if lastDiff > ERROR_MARGIN then _trigger "rotateRight"
      else if lastDiff < -ERROR_MARGIN then _trigger "rotateLeft"
      startAngle = undefined
      lastDiff = undefined
      triggered = false

  events: ["rotate", "rotating", "rotateLeft", "rotateRight"]
  start: start
  move: move
  end: end
