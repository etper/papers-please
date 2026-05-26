extends Control

func open_window(scene: PackedScene):

	var w = scene.instantiate()

	$WindowLayer.add_child(w)

	w.grab_focus()
