class_name SwipeControl extends Node

var isTouchDown = false
var dragStartPos;

func _input(event):
	if !(event is InputEventScreenTouch or event is InputEventMouseButton):
		return
	# drag begin
	if event.is_pressed():
		isTouchDown = true
		dragStartPos = event.position
	elif event.is_released():
			isTouchDown = false
			_check_swipe(event.position)
	else:
		if event.is_canceled():
			isTouchDown = false
			return

func _check_swipe(dragEndPos):
	var margin = 20
	var difference = dragStartPos - dragEndPos
	var x = abs(difference.x)
	var y = abs(difference.y)
	if x > y && margin < x:
		if difference.x > 0:
			_reportSwipe("left")
		elif difference.x < 0:
			_reportSwipe("right")
	elif x < y && margin < y:
		if difference.y > 0:
			_reportSwipe("up")
		elif difference.y < 0:
			_reportSwipe("down")

func _reportSwipe(direction):
	var scene = get_tree().root.get_child(0)
	scene.swipe_event(direction)
