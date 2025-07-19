class_name PowerUpOrb extends CharacterBody2D

var max_speed := 500.0
@onready var icon = $icon

func _ready() -> void:
	var type = PowerUpManager.available_power_ups.pick_random()
	var icon_texture = load(PowerUpManager.icon_map[type])
	icon.texture = icon_texture

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		var normal = collision.get_normal()
		var collider = collision.get_collider()
		velocity = velocity.bounce(normal)
		velocity = min(max_speed,velocity.length()) * velocity.normalized() 
		if collider is CharacterBody2D:
			collider.activate_power_up(self)
	
