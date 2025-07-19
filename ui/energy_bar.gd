extends TextureProgressBar

func _ready() -> void:
	max_value = UiDataManager.MAX_ENERGY
	value = 0
	UiDataManager.connect("update_energy_ui", update_value)

func update_value(energy: int):
	value = energy
