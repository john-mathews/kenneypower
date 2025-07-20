extends Node
signal level_ready(level: Node2D)

enum power_up_types {
	NONE, #default
	GROW, #permant size upgrade up to 1.0 scale
	SUPER, #makes paddle bigger (could be "super" and be faster too?)
	REPAIR, #repairs reactor damage instantly
	VACUUM, #sucks up and destroys particles near paddles
	FORCE_FIELD, #reactor damage costs energy instead of integrity
	COLD_FUSION, #spawner creates blue particles that heal instead of damage
	BLACK_HOLE #place small black hole in area that sucks up and destroys particles near it
}

var power_up_counter:= 0.0
var subtract_energy_timer:= .5
const max_powerup_time:= 15.0
var available_power_ups := [power_up_types.GROW, power_up_types.SUPER, power_up_types.REPAIR, power_up_types.COLD_FUSION]
const green_plus_icon_uid := 'uid://del7xqamxln8u'
const mushroom_scene_uid := 'uid://13kcww77ujv'
const lightning_scene_uid := 'uid://c0xs6shff5tbg'
const rain_drop_uid := 'uid://8t8oq5767mfy'
const vacuum_icon_uid := 'uid://ct88lnx57mtw'
var level : Node2D
var player_scale:= Vector2(1,1)
const repair_amount := 5
const grow_cost := 10
var vacuum_scene := preload('uid://b7gj4peoe7kwp')

var icon_map : Dictionary[power_up_types, String] = {
	power_up_types.GROW: mushroom_scene_uid,
	power_up_types.SUPER: lightning_scene_uid,
	power_up_types.REPAIR: green_plus_icon_uid,
	power_up_types.COLD_FUSION: rain_drop_uid,
	power_up_types.VACUUM: vacuum_icon_uid
}

var timer_dict : Dictionary[power_up_types, float] = {}

var active_power_up:= power_up_types.NONE
var current_power_ups: Array[power_up_types] = []

func _ready() -> void:
	connect("level_ready", set_level)
	update_available_from_energy(0)
	UiDataManager.connect('update_energy_ui', update_available_from_energy)
	
func update_available_from_energy(energy: int) -> void:
	if available_power_ups.size() == 0:
		available_power_ups.push_back(power_up_types.REPAIR)
		
	if energy >= 20 && power_up_types.VACUUM not in available_power_ups:
		available_power_ups.push_back(power_up_types.VACUUM)
	elif energy < 20 && power_up_types.VACUUM in available_power_ups:
		available_power_ups.erase(power_up_types.VACUUM)
	
	if energy >= 5 && power_up_types.SUPER not in available_power_ups:
		available_power_ups.push_back(power_up_types.SUPER)
	elif energy < 5 && power_up_types.SUPER in available_power_ups:
		available_power_ups.erase(power_up_types.SUPER)
		
	if energy >= 10 && power_up_types.COLD_FUSION not in available_power_ups:
		available_power_ups.push_back(power_up_types.COLD_FUSION)
	elif energy < 10 && power_up_types.COLD_FUSION in available_power_ups:
		available_power_ups.erase(power_up_types.COLD_FUSION)
		
	if energy >= 15 && power_up_types.GROW not in available_power_ups:
			available_power_ups.push_back(power_up_types.GROW)
	elif energy < 15 && power_up_types.GROW in available_power_ups:
		available_power_ups.erase(power_up_types.GROW)
		
func set_level(new_level:Node2D) -> void:
	level = new_level
	var player = level.players_container.get_child(0)
	player_scale = player.scale
	
	
func _process(delta: float) -> void:
	if current_power_ups.size() > 0:
		for power_up in current_power_ups:
			var time = timer_dict.get_or_add(power_up, 0.0)
			timer_dict[power_up] = time + delta
			if timer_dict[power_up] > max_powerup_time:
				remove_expired_power_up(power_up)
				
		@warning_ignore("integer_division")
		if power_up_counter < subtract_energy_timer:
			power_up_counter += delta
		else:
			UiDataManager.energy = max(0, UiDataManager.energy - 1)
			if UiDataManager.energy <= 0:
				reset()
			UiDataManager.update_energy_ui.emit(UiDataManager.energy)
			power_up_counter = 0.0

func activate_power_up(orb: PowerUpOrb, player: CharacterBody2D) -> void:
	if orb.power_type in current_power_ups:
		UiDataManager.score += 100
		UiDataManager.update_score_ui.emit(UiDataManager.score)
		timer_dict[orb.power_type] = 0.0
	else:
		match(orb.power_type):
			power_up_types.GROW:
				grow_players()
			power_up_types.SUPER:
				activate_super()
			power_up_types.REPAIR:
				UiDataManager.integrity = min(UiDataManager.MAX_INTEGRITY, UiDataManager.integrity + repair_amount)
				UiDataManager.update_integrity_ui.emit(UiDataManager.integrity)
			power_up_types.VACUUM:
				activate_vacuum(player)
			power_up_types.COLD_FUSION:
				current_power_ups.push_back(power_up_types.COLD_FUSION)
	orb.queue_free()
	
func activate_vacuum(player: CharacterBody2D) -> void:
	current_power_ups.push_back(power_up_types.VACUUM)
	if player.vacuum_spawn.get_child_count() == 0:
		var vacuum_inst = vacuum_scene.instantiate()
		vacuum_inst.scale = Vector2.ONE * (1.0/player_scale.x)
		player.vacuum_spawn.add_child(vacuum_inst)

func activate_super() -> void:
	if power_up_types.SUPER not in current_power_ups:
		current_power_ups.push_back(power_up_types.SUPER)
		for child in level.players_container.get_children():
			var tween = create_tween()
			tween.tween_property(child, 'scale', child.scale * 1.5, .5)
			child.speed_scale = 1.5
			
func grow_players()-> void:
	UiDataManager.energy = max(0, UiDataManager.energy - grow_cost)
	UiDataManager.update_energy_ui.emit(UiDataManager.energy)
	for child in level.players_container.get_children():
		var tween = create_tween()
		var new_scale = Vector2(child.scale.x +.1,child.scale.y+.1)
		tween.tween_property(child, 'scale', new_scale, .3)
		player_scale = new_scale
		
func reset_players(full:= false) -> void:
	for child in level.players_container.get_children():
		var tween = create_tween()
		tween.tween_property(child, 'scale', player_scale, .5)
		child.speed_scale = 1.0
		if child.vacuum_spawn.get_child_count() > 0:
			child.vacuum_spawn.get_child(0).queue_free()
		if full:
			child.position = child.init_spawn
			
			
func reset_players_scale() -> void:
	for child in level.players_container.get_children():
		var tween = create_tween()
		tween.tween_property(child, 'scale', player_scale, .5)
		child.speed_scale = 1.0
		
func reset_players_vacuum() -> void:
	for child in level.players_container.get_children():
		if child.vacuum_spawn.get_child_count() > 0:
			child.vacuum_spawn.get_child(0).queue_free()
		
func reset() -> void:
	current_power_ups = []
	reset_players()
	reset_timer_dict()

func full_reset()-> void:
	player_scale = Vector2(.5,.5)
	current_power_ups = []
	reset_players(true)
	reset_timer_dict()

func remove_expired_power_up(power_up: power_up_types) -> void:
	current_power_ups.erase(power_up)
	timer_dict[power_up] = 0.0
	if power_up == power_up_types.SUPER:
		reset_players_scale()
	elif power_up == power_up_types.VACUUM:
		reset_players_vacuum()
	
func reset_timer_dict() -> void:
	for key in timer_dict.keys():
		timer_dict[key] = 0.0
	
