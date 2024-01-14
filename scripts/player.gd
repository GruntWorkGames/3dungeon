extends CharacterBody3D

var isMoving = false
var animNode

func _ready():
	pass
	animNode = get_node("player_model/AnimationPlayer")
	animNode.idle()

func face_dir(dir):
	if isMoving:
		return
		
	var tweenRot = create_tween()
	var rotSpeed = 0.1

	match dir:
		"left":
			var target_ang = _get_tar_rotation(90)
			tweenRot.tween_property(self, "rotation:y", target_ang, rotSpeed)
		"right":
			var target_ang = _get_tar_rotation(-90)
			tweenRot.tween_property(self, "rotation:y", target_ang, rotSpeed)
		"up":
			var target_ang = _get_tar_rotation(0)
			tweenRot.tween_property(self, "rotation:y", target_ang, rotSpeed)
		"down":
			var target_ang = _get_tar_rotation(180)
			tweenRot.tween_property(self, "rotation:y", target_ang, rotSpeed)

func _get_tar_rotation(tarAngle):
	var diff_ang = deg_to_rad(tarAngle) - rotation.y
	diff_ang = wrapf(diff_ang, -PI, PI)
	return rotation.y + diff_ang

func move(dir, callback):
	if isMoving:
		return
		
	isMoving = true
	var newpos = Vector3(position)
	var tweenPos = get_tree().create_tween()
	var dist = 2
	var speed = 0.3

	match dir:
		"left":
			tweenPos.tween_property(self, "position:x", newpos.x - dist, speed).set_trans(Tween.TRANS_LINEAR)
			newpos.x = newpos.x - dist # use for snap to grid
		"right":
			tweenPos.tween_property(self, "position:x", newpos.x + dist, speed).set_trans(Tween.TRANS_LINEAR)
			newpos.x = newpos.x + dist
		"up":
			tweenPos.tween_property(self, "position:z", newpos.z - dist, speed).set_trans(Tween.TRANS_LINEAR)
			newpos.z = newpos.z - dist
		"down":
			tweenPos.tween_property(self, "position:z", newpos.z + dist, speed).set_trans(Tween.TRANS_LINEAR)
			newpos.z = newpos.z + dist
	tweenPos.tween_callback(_done.bind(newpos))
	tweenPos.tween_callback(callback)
	animNode.run()

func _done(newpos):
	position = newpos # snap to position
	isMoving = false
	animNode.idle()
