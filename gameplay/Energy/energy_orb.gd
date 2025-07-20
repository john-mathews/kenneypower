class_name EnergyOrb extends CharacterBody2D

var speed_increase := 20.0
var max_speed := 1000.0
var point_value := 1
var point_timer := 1.0
var point_counter := 0.0
var cold_fusion := false
@onready var sprite := $Sprite2D
@onready var player_hit := $PlayerHit

const blue_dot_uid := 'uid://ctpq8xv0sdmud'

func _ready() -> void:
	if cold_fusion:
		var tex = preload(blue_dot_uid)
		set_texture(tex)
		scale *= 1.5
		
	
func set_texture(tex: Texture2D):
	if sprite != null:
		sprite.texture = tex

func _physics_process(delta: float) -> void:
	if point_counter >= point_timer:
		UiDataManager.score += point_value
		UiDataManager.update_score_ui.emit(UiDataManager.score)
		point_counter = 0
	else:
		point_counter += delta
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		var normal = collision.get_normal()
		var collider = collision.get_collider()
		velocity = velocity.bounce(normal)
		velocity = min(max_speed,(velocity.length() + speed_increase)) * velocity.normalized() 
		if collider is CharacterBody2D:
			player_hit.play()
			if UiDataManager.energy < UiDataManager.MAX_ENERGY:
				UiDataManager.energy += 1
				UiDataManager.update_energy_ui.emit(UiDataManager.energy)
		elif collider is StaticBody2D && collider.is_reactor:
			if PowerUpManager.power_up_types.FORCE_FIELD in PowerUpManager.current_power_ups:
				pass #deflect subtracts energy instead of integrity
			elif cold_fusion:
				collider.heal_reactor()
				queue_free()
			else:
				collider.damage_reactor()
				disable_mask_1()
				var tween := create_tween()

				# Flash sprite modulate (visible → invisible → visible)
				tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 0.2)
				tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.3)

				# After flash, re-enable collision
				tween.tween_callback(func():
					enable_mask_1()
				)

func disable_mask_1():
	var mask := get_collision_mask()
	set_collision_mask(mask & ~1)  
	
func enable_mask_1():
	var mask := get_collision_mask()
	set_collision_mask(mask | 1) 
