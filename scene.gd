extends Node3D

var floor_builder = FloorBuilder.new()
var initialZ = 0

func _ready():
	floor_builder.createmap(self)
	initialZ = %player.position.z
	%player.position = floor_builder.getRandomTilePos()
	%player.position.z = initialZ

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		floor_builder.createmap(self)
		%player.position = floor_builder.getRandomTilePos()
		%player.position.z = initialZ
		
