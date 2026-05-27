extends Control

@onready var window_layer = $WindowLayer

var minimized_windows := []
var app_windows := {}

func open_app(scene: PackedScene):

	if scene == null:
		return null

	# app already exists
	if app_windows.has(scene):

		var existing = app_windows[scene]

		if is_instance_valid(existing):

			existing.visible = true
			existing.grab_focus()

			return existing

	# create new window
	var window = scene.instantiate()

	window_layer.add_child(window)

	window.visible = true

	window.position = Vector2(
		randi_range(120, 300),
		randi_range(80, 180)
	)

	window.grab_focus()

	connect_window_signals(window)

	app_windows[scene] = window

	return window

func connect_window_signals(window: Window):

	window.close_requested.connect(
		func():
			window.visible = false
	)

	window.visibility_changed.connect(
		func():
			if !window.visible:
				minimized_windows.append(window)
	)

func minimize_window(window: Window):

	window.visible = false
