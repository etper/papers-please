extends Node2D

var current_citizen: Citizen

var mistakes := 0
var processed := 0
var quota := 5

var current_day := 1

var needs_injection := false
var compliance := 100

func _ready():
	randomize()

	$RuleManager.set_day(current_day)

	current_citizen = generate_random_citizen()

	display_citizen(current_citizen)

func generate_random_citizen() -> Citizen:

	var c = Citizen.new()

	c.citizen_id = "SUBJECT-" + str(randi_range(100, 999))

	c.anxiety = randi_range(0, 100)
	c.aggression = randi_range(0, 100)
	c.grief = randi_range(0, 100)

	var possible_symbols = [
		"Bell",
		"Eye",
		"Ocean",
		"Blue Triangle"
	]

	c.dream_symbols.append(
		possible_symbols.pick_random()
	)

	c.risk_score = randi_range(0, 100)

	return c

func display_citizen(citizen: Citizen):

	$UI/BrainScanPanel/CitizenIDLabel.text = citizen.citizen_id

	$UI/BrainScanPanel/AnxietyLabel.text = \
		"Anxiety: " + str(citizen.anxiety) + "%"

	$UI/BrainScanPanel/AggressionLabel.text = \
		"Aggression: " + str(citizen.aggression) + "%"

	$UI/BrainScanPanel/GriefLabel.text = \
		"Grief: " + str(citizen.grief) + "%"

	$UI/BrainScanPanel/DreamSymbolsLabel.text = \
		"Dream Symbols: " + ", ".join(citizen.dream_symbols)

	$UI/BrainScanPanel/RiskLabel.text = \
		"Risk: " + str(citizen.risk_score)
	
	$UI/BrainScanPanel/RulesLabel.text = \
	$RuleManager.get_rules_text()

func finish_case():

	processed += 1

	print("Processed: ", processed)

	if mistakes >= 3:
		print("GAME OVER")
		return

	if processed >= quota:
		print("DAY COMPLETE")
		return

	needs_injection = true
	show_injection_ui()

func _on_approve_button_pressed():

	if needs_injection:
		print("INJECTION REQUIRED")
		return

	var should_reject = \
		$RuleManager.should_reject(current_citizen)

	if should_reject:

		mistakes += 1

		print("WRONG APPROVAL")
		print("Mistakes: ", mistakes)

	else:

		print("CORRECT APPROVAL")

	finish_case()

func _on_reject_button_pressed():

	if needs_injection:
		print("INJECTION REQUIRED")
		return

	var should_reject = \
		$RuleManager.should_reject(current_citizen)

	if should_reject:

		print("CORRECT REJECTION")

	else:

		mistakes += 1

		print("WRONG REJECTION")
		print("Mistakes: ", mistakes)

	finish_case()

func inject_drug():

	needs_injection = false

	compliance = 100

	print("COMPLIANCE RESTORED")

	current_citizen = generate_random_citizen()

	display_citizen(current_citizen)
	
	$UI/BrainScanPanel.visible = true
	$UI/InjectButton.visible = false

func show_injection_ui():

	$UI/BrainScanPanel.visible = false
	$UI/InjectButton.visible = true

func _on_inject_button_pressed() -> void:
	inject_drug()
