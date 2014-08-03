# Create a command to remember current state, and rever to that state
# Make it better by doing multiple of these

NUM_CELLS = 10

# Helper functions ------------------------------------------------------------

anchoredTop = (winFrame, screenFrame) ->
  winFrame.origin.y <= screenFrame.origin.y

anchoredBottom = (winFrame, screenFrame) ->
  frameBottomPos(winFrame) >= frameBottomPos(screenFrame)

anchoredLeft = (winFrame, screenFrame) ->
  winFrame.origin.x <= screenFrame.origin.x

anchoredRight = (winFrame, screenFrame) ->
  frameRightPos(winFrame) >= frameRightPos(screenFrame)

frameRightPos = (frame) ->
  frame.origin.x + frame.size.width

frameBottomPos = (frame) ->
  frame.origin.y + frame.size.height

adjustToMax = (frame) ->
  screenFrame = api.focusedWindow().screen().frameWithoutDockOrMenu()
  frame.origin.x = Math.max(frame.origin.x, screenFrame.origin.x)
  frame.origin.y = Math.max(frame.origin.y, screenFrame.origin.y)
  if frameRightPos(frame) > frameRightPos(screenFrame)
    frame.size.width = frameRightPos(screenFrame) - frame.origin.x
  if frameBottomPos(frame) > frameBottomPos(screenFrame)
    frame.size.height = frameBottomPos(screenFrame) - frame.origin.y
  frame

updateWindow = (win, fn) ->
  screenFrame = win.screen().frameWithoutDockOrMenu()
  newFrame = fn win.frame(), screenFrame if screenFrame
  win.setFrame adjustToMax newFrame if newFrame

updateFocused = (fn) ->
  focused = api.focusedWindow()
  updateWindow focused, fn if focused

# Implementations -------------------------------------------------------------

maximize = ->
  updateFocused (winFrame, screenFrame) -> screenFrame

topHalf = ->
  updateFocused (winFrame, screenFrame) ->
    screenFrame.size.height /= 2
    screenFrame

bottomHalf = ->
  updateFocused (winFrame, screenFrame) ->
    screenFrame.origin.y += screenFrame.size.height / 2
    screenFrame.size.height /= 2
    screenFrame

rightHalf = ->
  updateFocused (winFrame, screenFrame) ->
    screenFrame.origin.x += screenFrame.size.width / 2
    screenFrame.size.width /= 2
    screenFrame

leftHalf = ->
  updateFocused (winFrame, screenFrame) ->
    screenFrame.size.width /= 2
    screenFrame

growDown = ->
  updateFocused (winFrame, screenFrame) ->
    diffHeight = screenFrame.size.height / NUM_CELLS
    if anchoredBottom winFrame, screenFrame
      winFrame.size.height -= diffHeight
      winFrame.origin.y -= diffHeight
    else
      winFrame.size.height += diffHeight
    winFrame

growUp = ->
  updateFocused (winFrame, screenFrame) ->
    diffHeight = screenFrame.size.height / NUM_CELLS
    if anchoredTop winFrame, screenFrame
      winFrame.size.height -= diffHeight
    else
      winFrame.size.height += diffHeight
      winFrame.origin.y -= diffHeight
    winFrame

growRight = ->
  updateFocused (winFrame, screenFrame) ->
    diffWidth = screenFrame.size.width / NUM_CELLS
    if anchoredRight winFrame, screenFrame
      winFrame.size.width -= diffWidth
      winFrame.origin.x += diffWidth
    else
      winFrame.size.width += diffWidth
    winFrame

growLeft = ->
  updateFocused (winFrame, screenFrame) ->
    diffWidth = screenFrame.size.width / NUM_CELLS
    if anchoredLeft winFrame, screenFrame
      winFrame.size.width -= diffWidth
    else
      winFrame.size.width += diffWidth
      winFrame.origin.x -= diffWidth
    winFrame

# Bindings --------------------------------------------------------------------

bind "M", ["cmd", "alt"], -> maximize()
bind "K", ["cmd", "alt"], -> topHalf()
bind "J", ["cmd", "alt"], -> bottomHalf()
bind "L", ["cmd", "alt"], -> rightHalf()
bind "H", ["cmd", "alt"], -> leftHalf()
bind "J", ["cmd", "alt", "ctrl"], -> growDown()
bind "K", ["cmd", "alt", "ctrl"], -> growUp()
bind "L", ["cmd", "alt", "ctrl"], -> growRight()
bind "H", ["cmd", "alt", "ctrl"], -> growLeft()
