extends Area2D

@export var suck_radius := 100.0
@export var max_force := 1000.0
@export var delete_radius := 30.0  # How close before deletion

var sucked_bodies := []

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body is EnergyOrb:
		sucked_bodies.append(body)

func _on_body_exited(body):
	sucked_bodies.erase(body)

func _physics_process(delta):
	for body in sucked_bodies:
		var direction = global_position - body.global_position
		var distance = direction.length()

		if distance <= delete_radius:
			sucked_bodies.erase(body)
			body.queue_free()  
			continue

		# Normalized pull direction
		var normalized_dir = direction.normalized()

		# The closer they are, the stronger the pull
		var distance_factor = 1.0 - clamp(distance / suck_radius, 0.5, 1.0)
		var force = max_force * distance_factor
		body.velocity += normalized_dir * force
