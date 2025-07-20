extends Control

signal play_again(game_type: String)
signal main_menu()

@onready var final := $FinalScore
@onready var high := $HighScore


func setup() -> void:
	final.text = 'FINAL SCORE: ' + str(UiDataManager.score)
	if UiDataManager.mode == 'single':
		high.text = 'HIGH SCORE: ' + str(UiDataManager.high_score_single)
	elif UiDataManager.mode == 'coop':
		high.text = 'HIGH SCORE: ' + str(UiDataManager.high_score_coop)

func _on_play_again_pressed() -> void:
	play_again.emit(UiDataManager.mode)


func _on_main_menu_pressed() -> void:
	main_menu.emit()
