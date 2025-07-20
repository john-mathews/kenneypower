extends CharacterBody2D

var speed := 400.0
var init_spawn : Vector2
@export_enum("left", "right") var side := 'left'
@onready var vacuum_spawn := $VacuumSpawn
const vacuum_spawn_offset := Vector2(160, 0)
var vacuum:Area2D

func _ready() -> void:
	init_spawn = position
	if side == 'left':
		vacuum_spawn.position += vacuum_spawn_offset
	else:
		vacuum_spawn.position -= vacuum_spawn_offset
		
func _physics_process(delta: float) -> void:
	position.x = init_spawn.x
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
		if collider is EnergyOrb:
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
		elif collider is PowerUpOrb:
			PowerUpManager.activate_power_up(collider, self)

		
