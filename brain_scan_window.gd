extends Window

signal approve_pressed
signal reject_pressed

func _ready():

	$ApproveButton.pressed.connect(_on_approve_pressed)
	$RejectButton.pressed.connect(_on_reject_pressed)

func _on_approve_pressed():

	approve_pressed.emit()

func _on_reject_pressed():

	reject_pressed.emit()
