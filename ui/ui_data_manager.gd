extends Node

signal update_integrity_ui(integrity: int)
signal update_energy_ui(energy: int)
signal update_score_ui(score: int)

const MAX_INTEGRITY := 25
const MAX_ENERGY := 25
var score := 0
var high_score_single := 0
var high_score_coop := 0
var mode := 'single'
var integrity: int
var energy: int

func _ready() -> void:
	connect("update_score_ui", check_for_high_score)
	reset_data()
	
func reset_data() -> void:
	integrity = MAX_INTEGRITY
	update_integrity_ui.emit(integrity)
	score = 0
	update_score_ui.emit(score)
	energy = 0
	update_energy_ui.emit(energy)

func check_for_high_score(score: int) -> void:
	if mode == 'single':
		if score > high_score_single:
			high_score_single = score
	elif mode == 'coop':
		if score > high_score_coop:
			high_score_coop = score
	
