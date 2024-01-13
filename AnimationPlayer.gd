extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func run():
	speed_scale = 3
	play("run");
	var anim = get_animation("run")
	pass
	
func idle():
	play("idle");
	var anim = get_animation("idle")
	anim.loop = true
	speed_scale = 1
	pass
