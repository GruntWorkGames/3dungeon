extends Node3D

var floor_builder = FloorBuilder.new()

func _ready():
	floor_builder.createmap(self)
	%player.position = floor_builder.getRandomTilePos()

func _input(event):
	_checkExit()
	if _checkMouse(event):
		return
	if event.is_action_pressed("left"):
		%player.face_dir("left")
		if _can_move(%player,"left"):
			%player.move("left",_playerFinishedMove)
		return
	else: if event.is_action_pressed("right"):
		%player.face_dir("right")
		if _can_move(%player,"right"):
			%player.move("right",_playerFinishedMove)
		return
	else: if event.is_action_pressed("up"):
		%player.face_dir("up")
		if _can_move(%player,"up"):
			%player.move("up",_playerFinishedMove)
		return
	else: if event.is_action_pressed("down"):
		%player.face_dir("down")
		if _can_move(%player,"down"):
			%player.move("down",_playerFinishedMove)
		return

func _playerFinishedMove():
	pass

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
