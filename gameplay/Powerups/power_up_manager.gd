extends Node
signal level_ready(level: Node2D)

enum power_up_types {
	NONE, #default
	GROW, #permant size upgrade up to 1.0 scale
	SUPER, #makes paddle bigger (could be "super" and be faster too?)
	REPAIR, #repairs reactor damage instantly
	VACCUUM, #sucks up and destroys particles near paddles
	FORCE_FIELD, #reactor damage costs energy instead of integrity
	COLD_FUSION, #spawner creates blue particles that heal instead of damage
	BLACK_HOLE #place small black hole in area that sucks up and destroys particles near it
}

var power_up_counter:= 0.0
var subtract_energy_timer:= .5

var available_power_ups := [power_up_types.GROW, power_up_types.SUPER, power_up_types.REPAIR, power_up_types.COLD_FUSION]
const green_plus_icon_uid := 'uid://del7xqamxln8u'
const mushroom_scene_uid := 'uid://13kcww77ujv'
const lightning_scene_uid := 'uid://c0xs6shff5tbg'
const rain_drop_uid := 'uid://8t8oq5767mfy'
var level : Node2D
var player_scale:= Vector2(1,1)
const repair_amount := 10

var icon_map : Dictionary[power_up_types, String] = {
	power_up_types.GROW: mushroom_scene_uid,
	power_up_types.SUPER: lightning_scene_uid,
	power_up_types.REPAIR: green_plus_icon_uid,
	power_up_types.COLD_FUSION: rain_drop_uid
}

var active_power_up:= power_up_types.NONE
var current_power_ups: Array[power_up_types] = []

func _ready() -> void:
	connect("level_ready", set_level)
	
func set_level(new_level:Node2D) -> void:
	level = new_level
	var player = level.players_container.get_child(0)
	player_scale = player.scale
	
func _process(delta: float) -> void:
	if current_power_ups.size() > 0:
		if power_up_counter < subtract_energy_timer:
			power_up_counter += delta
		else:
			UiDataManager.energy = max(0, UiDataManager.energy - 1)
			if UiDataManager.energy <= 0:
				reset()
			UiDataManager.update_energy_ui.emit(UiDataManager.energy)
			power_up_counter = 0.0

func activate_power_up(orb: PowerUpOrb) -> void:
	if (orb.power_type in current_power_ups):
		UiDataManager.score += 100
		UiDataManager.update_score_ui.emit(UiDataManager.score)
	else:
		match(orb.power_type):
			power_up_types.GROW:
				grow_players()
			power_up_types.SUPER:
				activate_super()
			power_up_types.REPAIR:
				UiDataManager.integrity = min(UiDataManager.MAX_INTEGRITY, UiDataManager.integrity + repair_amount)
				UiDataManager.update_integrity_ui.emit(UiDataManager.integrity)
			power_up_types.VACCUUM:
				pass
			power_up_types.COLD_FUSION:
				current_power_ups.push_back(power_up_types.COLD_FUSION)
	orb.queue_free()

func activate_super() -> void:
	if power_up_types.SUPER not in current_power_ups:
		current_power_ups.push_back(power_up_types.SUPER)
		for child in level.players_container.get_children():
			var tween = create_tween()
			tween.tween_property(child, 'scale', child.scale * 1.5,.5)
			child.speed *= 1.5
			child.position = child.init_spawn
			
func grow_players()-> void:
	for child in level.players_container.get_children():
		var tween = create_tween()
		var new_scale = Vector2(child.scale.x +.1,child.scale.y+.1)
		tween.tween_property(child, 'scale', new_scale, .3)
		player_scale = new_scale
		
func reset_player_size() -> void:
	for child in level.players_container.get_children():
		var tween = create_tween()
		tween.tween_property(child, 'scale', player_scale, .5)

	
func reset() -> void:
	current_power_ups = []
	reset_player_size()
