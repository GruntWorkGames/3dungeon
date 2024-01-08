extends Node3D

var floor_builder = FloorBuilder.new()
var shouldContinue = false
var lastDirection

func _ready():
	floor_builder.createmap(self)
	%player.position = floor_builder.getRandomTilePos()

func _input(event):
	_checkExit()
	if _checkMouse(event):
		return
		
	# can only occur if from keyboard
	if !event.accumulate(event) and event.is_released():
		shouldContinue = false
	
	if event.is_action_pressed("left"):
		_move_entity(%player, "left")
		shouldContinue = true
		return
	else: if event.is_action_pressed("right"):
		_move_entity(%player, "right")
		shouldContinue = true
		return
	else: if event.is_action_pressed("up"):
		_move_entity(%player, "up")
		shouldContinue = true
		return
	else: if event.is_action_pressed("down"):
		_move_entity(%player, "down")
		shouldContinue = true
		return

func _move_entity(entity, direction):
	entity.face_dir(direction)
	if _can_move(entity,direction):
		lastDirection = direction
		entity.move(direction,_playerFinishedMove)

func _playerFinishedMove():
	if shouldContinue:
		_move_entity(%player,lastDirection)

func _checkExit():
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
 
func _checkMouse(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		floor_builder.createmap(self)
		%player.position = floor_builder.getRandomTilePos()
		return true
	return false	

func _can_move(entity, dir):
	var tile = floor_builder.posToTile(entity.position)
	match dir:
		"up":
			tile.z = tile.z - 1
		"down":
			tile.z = tile.z + 1
		"left":
			tile.x = tile.x - 1
		"right":
			tile.x = tile.x + 1
	return floor_builder.is_tile_open(tile)
