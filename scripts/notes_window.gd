extends Window

@onready var text_edit = $MarginContainer/TextEdit

const SAVE_PATH = "user://notes.save"

func _ready():

	load_notes()

	close_requested.connect(_on_close_requested)

func _on_close_requested():

	save_notes()
	visible = false

func save_notes():

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file:
		file.store_string(text_edit.text)

func load_notes():

	if !FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file:
		text_edit.text = file.get_as_text()
