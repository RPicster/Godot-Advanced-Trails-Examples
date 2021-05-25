extends Sprite

onready var orig_scale = scale

func _process(delta):
	scale = orig_scale * rand_range(0.5, 1.0)
