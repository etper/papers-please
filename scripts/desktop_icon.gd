extends Button

@export var app_scene: PackedScene
@export var icon_texture: Texture2D
@export var app_name := "APP"

var click_timer := 0.0
var click_count := 0

func _ready():

	$Icon.texture = icon_texture
	$Label.text = app_name

func _pressed():

	click_count += 1

	if click_count == 1:

		click_timer = 0.25

	else:

		open_app()

		click_count = 0

func _process(delta):

	if click_timer > 0:

		click_timer -= delta

		if click_timer <= 0:
			click_count = 0

func open_app():

	var desktop = get_tree().get_first_node_in_group("desktop")

	if desktop:
		desktop.open_app(app_scene)
