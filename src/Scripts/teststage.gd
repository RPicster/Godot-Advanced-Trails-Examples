extends Node2D

var Smoketrail = preload("res://Scenes/Smoketrail.tscn")
var Rocket = preload("res://Scenes/Rocket.tscn")
var Bullet = preload("res://Scenes/Bullet.tscn")

var can_shoot = true
onready var target = $Target
onready var firedeco = $Firedeco

func _process(delta):
	firedeco.global_position = get_global_mouse_position()
	
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		$can_shoot.start()
		var rocket = Rocket.instance()
		rocket.direction = Vector2.RIGHT.rotated(rand_range(-0.5, 0.5))
		rocket.position = get_global_mouse_position()
		rocket.target = target
		add_child(rocket)
		
		var bullet = Bullet.instance()
		bullet.direction = Vector2.RIGHT.rotated(rand_range(-0.05, 0.05))
		bullet.position = get_global_mouse_position() + Vector2(0,50)
		add_child(bullet)
		


func _on_can_shoot_timeout():
	can_shoot = true
