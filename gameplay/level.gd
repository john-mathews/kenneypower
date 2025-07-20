extends Node2D

@onready var orb_container := $Orbs
@onready var players_container := $Players
@onready var reactor := $Visuals/ReactorVisual
@onready var cam := $Camera2D
@onready var start_label := $CanvasLayer/StartLabel
@onready var game_ui : = $CanvasLayer/UI
@onready var  main_menu : = $CanvasLayer/MainMenu
@onready var  end_menu : = $CanvasLayer/EndMenu
var spawner_uid:= 'uid://8i7gyxy70r5d'
var spawner

var game_started = false
var game_paused = false

func _ready() -> void:
	PowerUpManager.level_ready.emit(self)
	reactor.position = get_center()
	main_menu.connect("start_pressed", setup_from_menu)
	end_menu.connect("play_again", setup_from_menu)
	end_menu.connect("main_menu", back_to_main)
	UiDataManager.connect("update_integrity_ui", check_integrity)
	
func back_to_main() -> void:
	main_menu.start_menu()
	main_menu.show()
	start_label.hide()
	end_menu.hide()
	game_ui.hide()
	

func setup_from_menu(game_type: String) -> void:
	UiDataManager.mode = game_type
	main_menu.hide()
	start_label.text = 'Press W, S, Up, or Down button to begin'
	start_label.show()
	game_ui.show()
	end_menu.hide()

func get_center() -> Vector2:
	return get_viewport().get_visible_rect().size / 2
	
func _input(event: InputEvent) -> void:
	var movement_pressed = event.is_action_pressed("left_up") || event.is_action_pressed("left_down") || event.is_action_pressed("right_up") || event.is_action_pressed("right_down")
	if !main_menu.visible && !end_menu.visible && !game_started && movement_pressed:
		start_game()
	elif game_started:
		start_label.hide()

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
	PowerUpManager.full_reset()
	end_menu.setup()
	end_menu.show()
	game_started = false
