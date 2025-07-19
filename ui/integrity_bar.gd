extends TextureProgressBar
@onready var label := $Label

func _ready() -> void:
	max_value = UiDataManager.MAX_INTEGRITY
	UiDataManager.connect("update_integrity_ui", update_value)

func update_value(integrity: int):
	value = integrity
	label.text = 'Reactor Integrity: ' + str(int(value)) + '/' + str(int(max_value))
