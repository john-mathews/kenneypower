extends Node2D

@onready var orb_container := $Orbs
@onready var players_container := $Players
@onready var reactor := $Visuals/ReactorVisual
@onready var cam := $Camera2D
@onready var start_label := $CanvasLayer/StartLabel
var spawner_uid:= 'uid://8i7gyxy70r5d'
var spawner

var game_started = false
var game_paused = false

func _ready() -> void:
	PowerUpManager.level_ready.emit(self)
	reactor.position = get_center()
	UiDataManager.connect("update_integrity_ui", check_integrity)

func get_center() -> Vector2:
	return get_viewport().get_visible_rect().size / 2
	
func _input(event: InputEvent) -> void:
	if !game_started && event.is_pressed():
		start_game()

func start_game() -> void:
	UiDataManager.reset_data()
	game_started = true
	start_label.hide()
	spawner = load(spawner_uid).instantiate()
	spawner.parent_scene = self
	spawner.position = get_center()
	add_child(spawner)

func check_integrity(integrity: int) -> void:
	if integrity <= 0:
		end_game()
		
func end_game() -> void:
	if spawner != null:
		spawner.queue_free()
	var orbs = orb_container.get_children()
	for orb in orbs:
		orb.queue_free()
	var final_score = str(UiDataManager.score)
	start_label.text = "SCORE: " + final_score + "\n \n PRESS ANY BUTTON TO START AGAIN"
	start_label.show()
	PowerUpManager.reset()
	await get_tree().create_timer(1.0).timeout
	game_started = false
