class_name PowerUpOrb extends CharacterBody2D

var max_speed := 500.0
@onready var icon_node = $icon
var power_type : PowerUpManager.power_up_types

func _ready() -> void:
	power_type = PowerUpManager.available_power_ups.pick_random()
	var icon = load(PowerUpManager.icon_map[power_type])
	if icon is PackedScene:
		var inst = icon.instantiate()
		add_child(inst)
	elif icon is Texture2D:
		icon_node.texture = icon



func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		var normal = collision.get_normal()
		var collider = collision.get_collider()
		velocity = velocity.bounce(normal)
		velocity = min(max_speed,velocity.length()) * velocity.normalized() 
		if collider is CharacterBody2D:
			PowerUpManager.activate_power_up(self)
	
