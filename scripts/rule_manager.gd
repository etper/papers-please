extends Node

var anxiety_limit := 40
var forbidden_symbols := []

func set_day(day: int):

	match day:

		1:
			anxiety_limit = 40
			forbidden_symbols = []

		2:
			anxiety_limit = 60
			forbidden_symbols = ["Bell", "Blue Triangle"]

		3:
			anxiety_limit = 30
			forbidden_symbols = ["Ocean"]

func should_reject(citizen: Citizen) -> bool:

	if citizen.anxiety > anxiety_limit:
		return true

	for symbol in citizen.dream_symbols:
		if symbol in forbidden_symbols:
			return true

	return false

func get_rules_text() -> String:

	var text = "RULES:\n"

	text += "Anxiety > " + str(anxiety_limit) + " = Reject\n"

	for symbol in forbidden_symbols:
		text += symbol + " Symbol = Reject\n"

	return text
