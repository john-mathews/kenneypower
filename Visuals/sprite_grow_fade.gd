extends Sprite2D

var default_color: Color
var pulse_scale:=Vector2(5, 5)

var yellow_texture :=preload('uid://cmjgno7e4x5wl')
var blue_texture	:=preload('uid://ctpq8xv0sdmud')

func _ready() -> void:
	scale = Vector2.ONE
	default_color = modulate
	animate_particle(self)
	
func _physics_process(_delta: float) -> void:
	rotation += deg_to_rad(1)
	if rotation > 2 * PI:
		rotation = 0

func animate_particle(particle: Sprite2D):
	if PowerUpManager.power_up_types.COLD_FUSION in PowerUpManager.current_power_ups:
		texture = blue_texture
	else:
		texture = yellow_texture
		
	var tween := create_tween()

	# Expand and fade
	tween.tween_property(particle, "scale", pulse_scale, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(particle, "scale", Vector2(.5, .5), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	
	tween.tween_interval(1.0)  # Wait 1 second before replay
	tween.tween_callback(Callable(self, "animate_particle").bind(particle))
