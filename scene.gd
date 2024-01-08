extends Node3D

var floor_builder = FloorBuilder.new()
var initialZ = 0

func _ready():
	floor_builder.createmap(self)
	initialZ = %player.position.z
	%player.position = floor_builder.getRandomTilePos()
	%player.position.z = initialZ

func _input(event):
	_checkExit()
	_checkMouse(event)

	if event.is_action_pressed("left"):
		%player.face_dir("left")
		%player.move("left",_playerFinishedMove)
		return
	else: if event.is_action_pressed("right"):
		%player.face_dir("right")
		%player.move("right",_playerFinishedMove)
		return
	else: if event.is_action_pressed("up"):
		%player.face_dir("up")
		%player.move("up",_playerFinishedMove)
		return
	else: if event.is_action_pressed("down"):
		%player.face_dir("down")
		%player.move("down",_playerFinishedMove)
		return

func _playerFinishedMove():
	print("player finished move")
	pass

func _checkExit():
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
 
func _checkMouse(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		floor_builder.createmap(self)
		%player.position = floor_builder.getRandomTilePos()
		%player.position.z = initialZ
