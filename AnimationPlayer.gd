extends AnimationPlayer

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
