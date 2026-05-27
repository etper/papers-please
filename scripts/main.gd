extends Node2D

var current_citizen: Citizen

var mistakes := 0
var processed := 0
var quota := 5

var current_day := 1

var needs_injection := false
var compliance := 100

var brain_window: Window = null

var cognitive_drift := false

func _ready():

	randomize()

	$RuleManager.set_day(current_day)

	var brain_window = get_brain_window()
	
	brain_window.hide()

	brain_window.approve_pressed.connect(_on_approve_button_pressed)
	brain_window.reject_pressed.connect(_on_reject_button_pressed)

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

	var window = get_brain_window()

	window.get_node("CitizenIDLabel").text = citizen.citizen_id

	window.get_node("AnxietyLabel").text = \
		"Anxiety: " + str(citizen.anxiety) + "%"

	window.get_node("AggressionLabel").text = \
		"Aggression: " + str(citizen.aggression) + "%"

	window.get_node("GriefLabel").text = \
		"Grief: " + str(citizen.grief) + "%"

	window.get_node("DreamSymbolsLabel").text = \
		"Dream Symbols: " + ", ".join(citizen.dream_symbols)

	window.get_node("RiskLabel").text = \
		"Risk: " + str(citizen.risk_score)

	window.get_node("RulesLabel").text = \
		$RuleManager.get_rules_text()

func finish_case():

	processed += 1

	print("Processed: ", processed)

	if mistakes >= 3:
		trigger_cognitive_drift()
		return

	if processed >= quota:
		print("DAY COMPLETE")
		return

	needs_injection = true
	show_injection_ui()

func _on_approve_button_pressed():

	if cognitive_drift:
		threat_confirmed()
		return

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

	get_brain_window().visible = true
	$UI/InjectButton.visible = false

func show_injection_ui():

	get_brain_window().visible = false
	$UI/InjectButton.visible = true

func _on_inject_button_pressed() -> void:
	inject_drug()

func trigger_cognitive_drift():

	cognitive_drift = true

	disable_normal_ui()

	show_drift_popup()

	await get_tree().create_timer(2.5).timeout

	start_self_audit()

func disable_normal_ui():

	get_brain_window().visible = false
	$UI/InjectButton.visible = false

func generate_self_audit() -> Citizen:

	var c = Citizen.new()

	c.citizen_id = "SUBJECT-YOU"

	c.anxiety = 99
	c.aggression = 91
	c.grief = 100

	c.dream_symbols = [
		"Bell",
		"Eye",
		"Blue Triangle"
	]

	c.risk_score = 100

	return c

func start_self_audit():

	current_citizen = generate_self_audit()

	display_citizen(current_citizen)

	get_brain_window().visible = true

func threat_confirmed():

	get_brain_window().visible = false

	print("THREAT CONFIRMED")

	await get_tree().create_timer(2.0).timeout

	restart_cycle()

func restart_cycle():

	mistakes = 0
	processed = 0
	compliance = 100

	current_day = 1

	cognitive_drift = false

	$RuleManager.set_day(current_day)

	current_citizen = generate_random_citizen()

	display_citizen(current_citizen)

	get_brain_window().visible = true

func show_drift_popup():

	print("AUDITOR COGNITIVE DRIFT DETECTED")

func get_brain_window():

	if is_instance_valid(brain_window):
		return brain_window

	var desktop = $UI/Desktop
	brain_window = desktop.open_app(
		preload("res://brain_scan_window.tscn")
	)

	brain_window.approve_pressed.connect(
		_on_approve_button_pressed
	)

	brain_window.reject_pressed.connect(
		_on_reject_button_pressed
	)

	return brain_window
