extends Window

@onready var rules_label = $MarginContainer/RichTextLabel

func set_rules(text: String):
	rules_label.text = text
