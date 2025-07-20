extends Node2D

@export var should_use_parent_material := false
@export var pulse_scale:=Vector2(5, 5)
@onready var pulse := $Pulse

func _ready() -> void:
	if should_use_parent_material:
		for child in get_children():
			child.use_parent_material = true
	pulse.pulse_scale = pulse_scale
