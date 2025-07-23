extends CanvasLayer

@onready var blocker := $ColorRect  # Fullscreen black
signal finished_out
signal finished_in

func start_out(style: String):
	match style:
		"fade": fade_out()
		"scroll": scroll_out()
		"flyout": fly_out()

func start_in(style: String):
	match style:
		"fade": fade_in()
		"scroll": scroll_in()
		"flyout": fly_in()

func fade_out():
	blocker.color.a = 0
	var tween := create_tween()
	tween.tween_property(blocker, "color:a", 1.0, 0.4)
	await tween.finished
	emit_signal("finished_out")

func fade_in():
	var tween := create_tween()
	tween.tween_property(blocker, "color:a", 0.0, 0.4)
	await tween.finished
	emit_signal("finished_in")

func scroll_out():
	blocker.position = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(blocker, "position", Vector2(-blocker.size.x, 0), 0.5).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	emit_signal("finished_out")

func scroll_in():
	blocker.position = Vector2(blocker.size.x, 0)
	var tween := create_tween()
	tween.tween_property(blocker, "position", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	emit_signal("finished_in")

func fly_out():
	blocker.scale = Vector2.ONE
	var tween := create_tween()
	tween.tween_property(blocker, "scale", Vector2(3, 3), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	emit_signal("finished_out")

func fly_in():
	blocker.scale = Vector2(3, 3)
	var tween := create_tween()
	tween.tween_property(blocker, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	emit_signal("finished_in")
