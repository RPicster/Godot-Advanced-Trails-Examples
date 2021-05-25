extends Node2D

var can_shoot_rocket := true
var can_shoot_bullet := true
var Rocket = preload("res://Scenes/Rocket.tscn")
var Bullet = preload("res://Scenes/Bullet.tscn")
var BulletEnemy = preload("res://Example_Game/Bullet_Enemy.tscn")

onready var player = $PlayerShip
onready var enemy = $Enemy
onready var tails_parent = $Enemy/Tails
onready var tails = [enemy.get_node("Tails/Tail"), enemy.get_node("Tails/Tail2")]
onready var enemy_orig_position : Vector2 = enemy.position
onready var enemy_pos_tween := $Enemy/EnemyPosTween


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	enemy_float()

func _process(delta):
	player.global_position = lerp(player.global_position, get_global_mouse_position(), 0.05)
	var pos_diff = clamp(abs(player.global_position.y - get_global_mouse_position().y), 1, 50) / 200
	player.scale.y = pos_diff + 1
	spawn_enemy_smoketrails()
	
	if Input.is_action_pressed("shoot"):
		if can_shoot_rocket:
			shoot_rocket()
		if can_shoot_bullet:
			shoot_bullet()


func enemy_float():
	var enemy_new_pos = enemy_orig_position + Vector2(rand_range(-20,20), rand_range(-100, 100))
	var enemy_move_time = max(enemy.position.distance_to(enemy_new_pos), 0.1) / 30
	enemy_pos_tween.interpolate_property(enemy, "position", enemy.position, enemy_new_pos, enemy_move_time, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	enemy_pos_tween.start()

func shoot_rocket():
	can_shoot_rocket = false
	$PlayerShip/Reload.start()
	$PlayerShip/AnimationPlayer.play("shoot")
	var rocket = Rocket.instance()
	rocket.direction = Vector2.RIGHT.rotated(rand_range(-0.6, 0.6))
	rocket.position = $PlayerShip/Muzzleflash.global_position
	rocket.target = enemy
	add_child(rocket)

func shoot_bullet():
	can_shoot_bullet = false
	$PlayerShip/Reload_Bullet.start()
	var bullet = Bullet.instance()
	bullet.direction = Vector2.RIGHT.rotated(rand_range(-0.05, 0.05))
	bullet.position = $PlayerShip/Muzzleflash.global_position
	add_child(bullet)

func shoot_enemy_bullet():
	var bullet = BulletEnemy.instance()
	bullet.direction = Vector2.LEFT.rotated(rand_range(-0.05, 0.05))
	bullet.position = $Enemy/Polygon2D3/ShootPos.global_position
	add_child(bullet)

func _on_Reload_timeout():
	can_shoot_rocket = true

func _on_Reload_Bullet_timeout():
	can_shoot_bullet = true

func spawn_enemy_smoketrails():
	for t in tails:
		t.add_point(tails_parent.global_position)


func _on_EnemyPosTween_tween_all_completed():
	enemy_float()


func _on_ReloadEnemy_timeout():
	shoot_enemy_bullet()
