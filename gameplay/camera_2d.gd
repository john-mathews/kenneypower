extends Camera2D

@export var shake_strength := 10.0
@export var shake_duration := 0.3

var shake_timer := 0.0
var rng := RandomNumberGenerator.new()
var current_integrity := UiDataManager.MAX_INTEGRITY
var init_pos: Vector2

func _ready():
	init_pos = position
	UiDataManager.connect("update_integrity_ui", should_shake)
	rng.randomize()

func _process(delta):
	if shake_timer > 0.0:
		shake_timer -= delta
		offset = Vector2(
			rng.randf_range(-shake_strength, shake_strength),
			rng.randf_range(-shake_strength, shake_strength)
		)
		offset *= shake_timer / shake_duration  # fade out
		position = offset + init_pos
	else:
		position = init_pos

func trigger_shake():
	shake_timer = shake_duration

func should_shake(integrity: int):
	if integrity < current_integrity:
		trigger_shake()
	current_integrity = integrity
