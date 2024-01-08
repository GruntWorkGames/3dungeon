extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
@onready var pivot = $camOrigin
@export var sensitivity = 0.1
var timetween
var spritetween
var isMoving = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

func face_dir(dir):
	var tweenRot = create_tween()
	var rotSpeed = 0.1

	match dir:
		"left":
			tweenRot.tween_property(self, "rotation:y", deg_to_rad(90), rotSpeed)
		"right":
			tweenRot.tween_property(self, "rotation:y", deg_to_rad(-90), rotSpeed)
		"up":
			tweenRot.tween_property(self, "rotation:y", deg_to_rad(0), rotSpeed)
		"down":
			tweenRot.tween_property(self, "rotation:y", deg_to_rad(-180), rotSpeed)

func move(dir, callback):
	if !isMoving:
		isMoving = true
		var newpos = Vector3(position)
		var tweenPos = get_tree().create_tween()
		var dist = 2
		var speed = 0.3

		match dir:
			"left":
				tweenPos.tween_property(self, "position:x", newpos.x - dist, speed).set_trans(Tween.TRANS_CUBIC)
				newpos.x = newpos.x - dist # use for snap to grid
			"right":
				tweenPos.tween_property(self, "position:x", newpos.x + dist, speed).set_trans(Tween.TRANS_CUBIC)
				newpos.x = newpos.x + dist
			"up":
				tweenPos.tween_property(self, "position:z", newpos.z - dist, speed).set_trans(Tween.TRANS_CUBIC)
				newpos.z = newpos.z - dist
			"down":
				tweenPos.tween_property(self, "position:z", newpos.z + dist, speed).set_trans(Tween.TRANS_CUBIC)
				newpos.z = newpos.z + dist
		tweenPos.tween_callback(_done.bind(newpos))
		tweenPos.tween_callback(callback)

func _done(landingPos):
	position = landingPos # snap to position
	isMoving = false
