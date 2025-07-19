extends Label

func _ready() -> void:
	UiDataManager.connect("update_score_ui", _on_score_update)
	
func _on_score_update(score: int):
	text = 'SCORE: ' + str(score)
