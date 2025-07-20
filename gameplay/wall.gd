extends StaticBody2D

@export var is_reactor:= false
@onready var sprite := $Sprite2D
@onready var reactor_hit := $ReactorHit
@onready var cf_hit := $ColdFusionReactorHit
var reactor_sprite := 'uid://dotca4hg3jawq'

func _ready() -> void:
	if is_reactor:
		var reactor_texture = load(reactor_sprite)
		sprite.texture = reactor_texture

func damage_reactor(damage: int = 1):
	reactor_hit.play()
	UiDataManager.integrity -= damage
	UiDataManager.update_integrity_ui.emit(UiDataManager.integrity)

func heal_reactor(heal: int = 5):
	cf_hit.play()
	UiDataManager.integrity += 5
	UiDataManager.update_integrity_ui.emit(UiDataManager.integrity)
