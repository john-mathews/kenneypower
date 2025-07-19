extends Node

signal update_integrity_ui(integrity: int)
signal update_energy_ui(energy: int)
signal update_score_ui(score: int)

const MAX_INTEGRITY := 10
const MAX_ENERGY := 20
var score := 0
var integrity: int
var energy: int

func _ready() -> void:
	reset_data()
	
func reset_data() -> void:
	integrity = MAX_INTEGRITY
	update_integrity_ui.emit(integrity)
	score = 0
	update_score_ui.emit(score)
	energy = 0
	update_energy_ui.emit(energy)
