extends CharacterBody2D

var speed := 500.0
@export_enum("left", "right") var side := 'left'

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed(side + '_up'):
		velocity.y = -speed
	elif Input.is_action_pressed(side + '_down'):
		velocity.y = speed
	else:
		velocity.y = 0
	
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		var normal = collision.get_normal()
		var collider = collision.get_collider()
		if collider is CharacterBody2D:
			if UiDataManager.energy < UiDataManager.MAX_ENERGY:
				UiDataManager.energy += 1
				UiDataManager.update_energy_ui.emit(UiDataManager.energy)
			var combined_vel = velocity + collider.velocity
			collider.velocity = combined_vel.bounce(normal)
			collider.velocity = combined_vel.length() * combined_vel.normalized() 
			if side == 'left':
				collider.velocity.x = abs(collider.velocity.x)
			else:
				collider.velocity.x = -abs(collider.velocity.x)
				
