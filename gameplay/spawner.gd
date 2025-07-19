extends Node2D

var orb_uid := 'uid://ccopb4164r4x4'
@export var parent_scene: Node2D
var starting_speed:= 250.0
var spawn_seconds := 5.0
var spawn_counter := 4.0

func spawn_orb():
	if parent_scene != null:
		var new_orb = load(orb_uid).instantiate()
		new_orb.position = position
		var rand_x = randf()
		var rand_y = (rand_x / 2) * (randf() + .3)

		new_orb.velocity = Vector2(maybe_negative(rand_x),maybe_negative(rand_y)).normalized() * starting_speed
		var x_vel = new_orb.velocity.x
		parent_scene.orb_container.add_child(new_orb);
		spawn_counter = 0.0
	
func _process(delta: float) -> void:
	if spawn_counter < spawn_seconds:
		spawn_counter += delta
	else:
		spawn_orb()

func maybe_negative(num: float):
	var sign = 1 if randi() % 2 == 0 else -1
	return num * sign
