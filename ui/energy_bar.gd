extends TextureProgressBar

@onready var label := $EnergyLabel
var max_energy: int

func _ready() -> void:
	max_value = UiDataManager.MAX_ENERGY
	value = 0
	UiDataManager.connect("update_energy_ui", update_value)

func update_value(energy: int):
	value = energy
	label.text = 'Power: ' + str(int(value)) + '/' + str(int(max_value))
