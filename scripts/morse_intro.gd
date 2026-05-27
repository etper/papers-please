extends Control

signal intro_finished

@onready var rec_label = $RecLabel
@onready var static_player = $StaticPlayer
@onready var beep_player = $BeepPlayer

var morse_message := "... .- ...- . / ..--- ----- ...."

func _ready():

	static_player.play()

	blink_rec()

	await get_tree().create_timer(2.0).timeout

	await play_morse(morse_message)

	await get_tree().create_timer(1.0).timeout

	intro_finished.emit()

func _input(event):

	if event.is_action_pressed("ui_accept"):

		intro_finished.emit()

func blink_rec():

	while true:

		rec_label.visible = !rec_label.visible

		await get_tree().create_timer(0.5).timeout

func play_morse(code: String) -> void:

	for char in code:

		match char:

			".":
				await play_beep(0.1)

			"-":
				await play_beep(0.3)

			" ":
				await get_tree().create_timer(0.2).timeout

			"/":
				await get_tree().create_timer(0.6).timeout

		await get_tree().create_timer(0.1).timeout

func play_beep(length: float) -> void:

	beep_player.play()

	await get_tree().create_timer(length).timeout

	beep_player.stop()
