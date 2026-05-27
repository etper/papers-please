extends Window

signal citizen_selected(citizen)

@onready var list_container = \
	$MarginContainer/ScrollContainer/VBoxContainer

var selected_button: Button = null

func set_queue(queue: Array):

	for child in list_container.get_children():
		child.queue_free()

	for citizen in queue:

		var button = Button.new()

		button.text = citizen.citizen_id
		button.flat = true

		button.pressed.connect(
			func():

				if selected_button:
					selected_button.modulate = Color.WHITE

				selected_button = button

				button.modulate = Color(0.6, 1.0, 0.6)

				citizen_selected.emit(citizen)
		)

		list_container.add_child(button)
