extends Node2D
@export var parent:=Node2D

func _input(event: InputEvent) -> void:
	if parent != null:
		if event.is_action_pressed("pause") && !parent.game_paused:
			parent.start_label.text = "Paused"
			get_tree().paused = true
			parent.game_paused = true
			parent.start_label.show()
		elif event.is_action_pressed("pause") && parent.game_paused:
			get_tree().paused = false
			parent.game_paused = false
			parent.start_label.hide()
