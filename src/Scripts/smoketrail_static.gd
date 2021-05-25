extends Line2D

export var limited_lifetime := false
export var wildness := 3.0
export var gravity := Vector2.UP
export var wind := Vector2(15,5)
export var gradient_col : Gradient = Gradient.new()
export var max_points := 30
export var tick_speed := 0.05

var lifetime := [0.5, 0.8]
var tick := 0.0
var wild_speed := 0.01
var point_age := [0.0]
var noise : OpenSimplexNoise = OpenSimplexNoise.new()
var wind_sway := 0.0
var turbulence := 2.0
var tile_move_time := 0.0

onready var tween := $Decay

func _ready():
	noise.octaves = 5
	gradient = gradient_col
	set_as_toplevel(true)
	clear_points()
	if limited_lifetime:
		stop()


func stop():
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, rand_range(lifetime[0], lifetime[1]), Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()


func _process(delta):
	tile_move_time = wrapf(tile_move_time + delta * 20, 0, 2000)
	
	if tick > tick_speed:
		tick = 0
		for p in range( get_point_count() ):
			if p == get_point_count()-1:
				continue
			point_age[p] += 5*delta
			var noise_x = points[p].x + tile_move_time * turbulence
			var noise_y = points[p].y + tile_move_time * turbulence
			wind_sway = lerp(wind_sway, noise.get_noise_2d( noise_x, noise_y) * ( point_age[p] * 0.5 ), 0.2)
			var rand_vector := Vector2( rand_range(-wild_speed, wild_speed), rand_range(-wild_speed, wild_speed) )
			points[p] += gravity + ( rand_vector * wildness * point_age[p] ) + ( wind * wind_sway )

	else:
		tick += delta


func add_point(point_pos:Vector2, at_pos := -1):
	if get_point_count() > max_points:
		remove_point(0)
		point_age.pop_front()
	
	point_age.append(0.0)
	.add_point(point_pos, at_pos)


func _on_Decay_tween_all_completed():
	queue_free()
