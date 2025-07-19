extends CharacterBody2D

var speed_increase := 20.0
var max_speed := 1000.0
var point_value := 1
var point_timer := 1.0
var point_counter := 0.0


func _physics_process(delta: float) -> void:
	if point_counter >= point_timer:
		UiDataManager.score += point_value
		point_counter = 0
	else:
		point_counter += delta
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		var normal = collision.get_normal()
		var collider = collision.get_collider()
		velocity = velocity.bounce(normal)
		if collider is CharacterBody2D:
			if UiDataManager.energy < UiDataManager.MAX_ENERGY:
				UiDataManager.energy += 1
				UiDataManager.update_energy_ui.emit(UiDataManager.energy)
			velocity = min(max_speed,(velocity.length() + speed_increase)) * velocity.normalized() 
		elif collider is StaticBody2D && collider.is_reactor: 
			collider.damage_reactor()
	
