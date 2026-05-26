extends Control

@onready var boot_text = $BootText
@onready var cursor = $Cursor

var lines = [
	"did i forget something?",
	"no...",
	"start again.",
	"you already know what happens.",
	"",
	"NEURAL COMPLIANCE SYSTEM v3.1",
	"BOOTING...",
	"MEMORY CHECK........OK",
	"EMOTIONAL FILTER....OK",
	"DATE: FEBRUARY 31ST 1982",
	"MONTH: 13",
	"DAY INDEX: 442",
	"AUDITOR STATUS: STABLE",
	"",
	"PRESS ANY KEY TO BEGIN"
]

var finished = false

func _ready():

	boot_text.visible_ratio = 1.0

	boot_sequence()

	blink_cursor()

func boot_sequence() -> void:

	# INTERNAL MONOLOGUE

	await type_line("did i forget something?", 0.06)

	boot_text.text += "\n"

	await get_tree().create_timer(1.4).timeout

	await type_line("no...", 0.12)

	boot_text.text += "\n"

	await get_tree().create_timer(1.8).timeout

	await type_line("start again.", 0.08)

	boot_text.text += "\n"

	await get_tree().create_timer(2.2).timeout

	await type_line(
		"you already know what happens.",
		0.05
	)

	# LONG SILENCE

	await get_tree().create_timer(3.0).timeout

	await get_tree().create_timer(3.0).timeout

	boot_text.clear()

	await get_tree().create_timer(1.2).timeout

	# SYSTEM BOOT

	var boot_lines = [
		"NEURAL COMPLIANCE SYSTEM v3.1",
		"BOOTING...",
		"MEMORY CHECK........OK",
		"EMOTIONAL FILTER....OK",
		"DATE: FEBRUARY 31ST 1982",
		"MONTH: 13",
		"DAY INDEX: 442",
		"AUDITOR STATUS: STABLE",
		"",
		"PRESS ANY KEY TO BEGIN"
	]

	for line in boot_lines:

		# occasional lag spike

		if randf() < 0.25:

			await get_tree().create_timer(
				randf_range(0.15, 0.5)
			).timeout

		await type_line(line, 0.018)

		boot_text.text += "\n"

		await get_tree().create_timer(0.05).timeout

	finished = true

func type_line(
	text_line: String,
	speed := 0.03
) -> void:

	for c in text_line:

		boot_text.text += c

		update_cursor()

		await get_tree().create_timer(speed).timeout



func blink_cursor() -> void:

	while true:

		cursor.visible = !cursor.visible

		await get_tree().create_timer(0.5).timeout

func update_cursor() -> void:

	cursor.position = Vector2(
		boot_text.position.x + 12,
		boot_text.position.y + boot_text.size.y + 8
	)

func _input(event):

	if event.is_pressed() and finished:

		get_tree().change_scene_to_file(
			"res://main.tscn"
		)
