extends Node

signal update_integrity_ui(integrity: int)
signal update_energy_ui(energy: int)

const MAX_INTEGRITY := 10
const MAX_ENERGY := 20
var score := 0
var integrity: int
var energy: int

func _ready() -> void:
	integrity = MAX_INTEGRITY
