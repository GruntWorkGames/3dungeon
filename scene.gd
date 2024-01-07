extends Node3D

var floor_builder = FloorBuilder.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_builder.createmap(self)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		floor_builder.createmap(self)				
