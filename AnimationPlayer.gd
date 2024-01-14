extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func run():
	speed_scale = 3
	play("run");
	pass
	
func idle():
	play("idle");
	var anim = get_animation("idle")
	anim.loop = true
	speed_scale = 1
	pass
