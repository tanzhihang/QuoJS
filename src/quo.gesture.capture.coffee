Quo.Gesture = Quo.Gesture or {}
Quo.Gesture.Capturer = do ($$ = Quo) ->

  getFingersPositions = (event) ->
    touches = _getVendorTouchData event
    positions = []
    positions.push {x: touch.pageX, y: touch.pageY} for touch in touches
    positions

  _getVendorTouchData = (event) ->
    touches = if $$.isMobile() then event.touches else [event]
    if touches[0]?.targetTouches then return touches[0].targetTouches
    else if touches then return touches
    else return false

  getTarget = (event) -> $$ event.target

  getTarget: getTarget
  getFingersPositions: getFingersPositions
