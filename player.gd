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
	
func _input(event):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if event.is_action_pressed("left"):
		move("left")
	else: if event.is_action_pressed("right"):
		move("right")
	else: if event.is_action_pressed("up"):
		move("up")
	else: if event.is_action_pressed("down"):
		move("down")			

func _physics_process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()	

func move(dir):
	if !isMoving:
		isMoving = true
		var newpos = Vector3(position)
		var tweenPos = create_tween().set_loops()
		var tweenRot = create_tween().set_loops()
		var dist = 2
		var speed = 0.4
		var rotSpeed = 0.1
		
		match dir:
			"left":
				tweenPos.tween_property(self, "position:x", newpos.x - dist, speed)
				tweenRot.tween_property(self, "rotation:y", deg_to_rad(90), rotSpeed)
			"right":
				tweenPos.tween_property(self, "position:x", newpos.x + dist, speed)
				tweenRot.tween_property(self, "rotation:y", deg_to_rad(-90), rotSpeed)
			"up":
				tweenPos.tween_property(self, "position:z", newpos.z - dist, speed)
				tweenRot.tween_property(self, "rotation:y", deg_to_rad(0), rotSpeed)
			"down":
				tweenPos.tween_property(self, "position:z", newpos.z + dist, speed)
				tweenRot.tween_property(self, "rotation:y", deg_to_rad(-180), rotSpeed)
		tweenPos.tween_callback(done)

func done():
	isMoving = false
	pass
