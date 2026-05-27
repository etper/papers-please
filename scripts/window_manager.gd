extends Control

@onready var window_layer = $WindowLayer

var minimized_windows := []

func open_app(scene: PackedScene):

	if scene == null:
		return

	var window = scene.instantiate()

	window_layer.add_child(window)

	window.visible = true

	window.position = Vector2(
		randi_range(120, 300),
		randi_range(80, 180)
	)

	window.grab_focus()

	connect_window_signals(window)

func connect_window_signals(window: Window):

	window.close_requested.connect(
		func():
			window.queue_free()
	)

	window.visibility_changed.connect(
		func():
			if !window.visible:
				minimized_windows.append(window)
	)

func minimize_window(window: Window):

	window.visible = false
