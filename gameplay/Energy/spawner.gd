extends Node2D

var orb_uid := 'uid://ccopb4164r4x4'
var power_up_uid := 'uid://cd3p3qphun8m1'
@export var parent_scene: Node2D
var starting_speed:= 250.0
var spawn_seconds := 6.0
var min_spawn_seconds := 2.0
var spawn_counter := spawn_seconds - 1.0
var total_counter := 0.0

var power_up_spawn_seconds := 8.0
var min_power_up_seconds := 4.0
var power_up_counter:= -2.0



func spawn_orb():
	if parent_scene != null:
		var cold_fusion = PowerUpManager.power_up_types.COLD_FUSION in PowerUpManager.current_power_ups
		var new_orb = load(orb_uid).instantiate()
		new_orb.cold_fusion = cold_fusion
		new_orb.position = position
		var rand_x = randf()
		var rand_y = (rand_x / 2) * (randf() + .3)

		new_orb.velocity = Vector2(maybe_negative(rand_x),maybe_negative(rand_y)).normalized() * starting_speed
		parent_scene.orb_container.add_child(new_orb);
		spawn_counter = 0.0
		
func spawn_power_up():
	if parent_scene != null:
		if spawn_seconds > min_spawn_seconds:
			var quarter_minutes = floori(total_counter/15)
			spawn_seconds = max(min_spawn_seconds, spawn_seconds - quarter_minutes)
			power_up_spawn_seconds = max(min_power_up_seconds, power_up_spawn_seconds - quarter_minutes)
		var new_orb = load(power_up_uid).instantiate()
		new_orb.position = position
		var rand_x = randf()
		var rand_y = (rand_x / 2) * randf() 

		new_orb.velocity = Vector2(maybe_negative(rand_x),maybe_negative(rand_y)).normalized() * starting_speed
		parent_scene.orb_container.add_child(new_orb);
		power_up_counter = 0.0
	
func _process(delta: float) -> void:
	total_counter += delta
	if spawn_counter < spawn_seconds:
		spawn_counter += delta
	else:
		spawn_orb()
		
	if power_up_counter < power_up_spawn_seconds:
		power_up_counter += delta
	else:
		spawn_power_up()

func maybe_negative(num: float):
	var aSign = 1 if randi() % 2 == 0 else -1
	return num * aSign
