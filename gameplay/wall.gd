extends StaticBody2D

@export var is_reactor:= false
@onready var sprite := $Sprite2D
var reactor_sprite := 'uid://dotca4hg3jawq'

func _ready() -> void:
	if is_reactor:
		var reactor_texture = load(reactor_sprite)
		sprite.texture = reactor_texture

func damage_reactor(damage: int = 1):
	UiDataManager.integrity -= damage
	UiDataManager.update_integrity_ui.emit(UiDataManager.integrity)

func heal_reactor(heal: int = 5):
	UiDataManager.integrity += 5
	UiDataManager.update_integrity_ui.emit(UiDataManager.integrity)
