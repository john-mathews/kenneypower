extends Node2D

@onready var orb_container := $Orbs
@onready var start_label := $CanvasLayer/StartLabel
var spawner_uid:= 'uid://8i7gyxy70r5d'

var game_started = false

func get_center() -> Vector2:
	return get_viewport().get_visible_rect().size / 2
	
func _input(event: InputEvent) -> void:
	if !game_started && event.is_pressed():
		start_game()

func start_game() -> void:
	game_started = true
	start_label.hide()
	var spawner = load(spawner_uid).instantiate()
	spawner.parent_scene = self
	spawner.position = get_center()
	add_child(spawner)
