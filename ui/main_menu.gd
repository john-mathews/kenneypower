extends Control

signal start_pressed(game_type: String)

@onready var single_label := $SingleScore
@onready var coop_label := $CoopScore

func start_menu() -> void:
	single_label.text = 'HIGH SCORE: ' + str(UiDataManager.high_score_single)
	coop_label.text = 'HIGH SCORE: ' + str(UiDataManager.high_score_coop)

func _ready() -> void:
	start_menu()

func _on_single_button_pressed() -> void:
	start_pressed.emit('single')


func _on_coop_button_pressed() -> void:
	start_pressed.emit('coop')
