extends StaticBody2D

@export var is_reactor:= false
@onready var sprite := $Sprite2D
var reactor_sprite := 'uid://dotca4hg3jawq'

func _ready() -> void:
	if is_reactor:
		var reactor_texture = load(reactor_sprite)
		sprite.texture = reactor_texture

func damage_reactor():
	UiDataManager.integrity -= 1
	UiDataManager.update_integrity_ui.emit(UiDataManager.integrity)

func heal_reactor():
	UiDataManager.integrity += 5
	UiDataManager.update_integrity_ui.emit(UiDataManager.integrity)
