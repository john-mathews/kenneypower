extends Node

@export var transition_layer_uid := "uid://43ty31wayqbl"

var current_scene: Node = null
var transitioning := false

func _ready():
	current_scene = get_tree().get_current_scene()

func change_scene(path: String, transition: String = "fade"):
	if transitioning: return
	transitioning = true

	var transition_layer : CanvasLayer = load(transition_layer_uid).instantiate()
	get_tree().root.add_child(transition_layer)

	transition_layer.start_out(transition)
	await transition_layer.finished_out

	# Replace scene
	if current_scene:
		current_scene.queue_free()
	current_scene = load(path).instantiate()
	get_tree().root.add_child(current_scene)

	transition_layer.start_in(transition)
	await transition_layer.finished_in

	transition_layer.queue_free()
	transitioning = false
