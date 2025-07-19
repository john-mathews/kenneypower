extends Sprite2D

@export var rotating_clockwise := false

func _ready():
	start_random_rotation()

func start_random_rotation():
	var from_angle = rotation
	var angle_change = randf_range(30.0, 180.0) * (1 if rotating_clockwise else -1)
	var to_angle = from_angle + deg_to_rad(angle_change)
	var duration = randf_range(0.5, 2.0)

	var tween := create_tween()
	tween.tween_property(self, "rotation", to_angle, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	rotating_clockwise = !rotating_clockwise
	await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
	start_random_rotation()
