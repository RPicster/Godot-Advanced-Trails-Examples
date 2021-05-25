extends Area2D

onready var smoketrail = $Smoketrail

var direction := Vector2.RIGHT
var speed := 5.0
var is_dead := false
var target : Object = null

func _process(_delta):
	if !is_dead:
		position += direction * speed
		smoketrail.add_point(global_position)
		direction = lerp(direction.rotated(rand_range(-0.3, 0.3)), global_position.direction_to(target.global_position), 0.05)

func _on_Bullet_body_entered(_body):
	if !is_dead:
		is_dead = true
		smoketrail.stop()
		speed = 0.0
		$AnimationPlayer.play("explosion")


func _on_Timer_timeout():
	_on_Bullet_body_entered(null)
