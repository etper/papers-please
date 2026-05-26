extends Node

var anxiety_limit := 40

var forbidden_symbols := [
	"Bell"
]


func should_reject(citizen: Citizen) -> bool:

	if citizen.anxiety > anxiety_limit:
		return true

	for symbol in citizen.dream_symbols:
		if symbol in forbidden_symbols:
			return true

	return false
