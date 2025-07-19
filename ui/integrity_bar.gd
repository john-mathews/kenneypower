extends TextureProgressBar

func _ready() -> void:
	max_value = UiDataManager.MAX_INTEGRITY
	UiDataManager.connect("update_integrity_ui", update_value)

func update_value(integrity: int):
	value = integrity
