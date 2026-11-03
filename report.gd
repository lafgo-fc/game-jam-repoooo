
extends Control

@onready var cars_label: Label = $"cars passed"
@onready var wait_label: Label = $"wait time"
@onready var accidents_label: Label = $Label8
@onready var reputation_label: Label = $Reputation
@onready var grade_label: Label = $Grade
@onready var day_label: Label = $day
@onready var shift_label: Label = $Shift
@onready var continue_button: Button = $ContinueButton

func _ready() -> void:
	update_report()

	continue_button.pressed.connect(
		_on_continue_button_pressed
	)


func update_report() -> void:
	cars_label.text = str(GameData.car_passed)

	wait_label.text = str(
		round(GameData.average_waiting_time)
	) + " sec"

	accidents_label.text = str(GameData.accidents)

	reputation_label.text = str(GameData.reputation)

	day_label.text = "DAY " + str(GameData.day)

	shift_label.text = GameData.current_shift + " shift"

	grade_label.text = calculate_grade()

	if GameData.day >= 7:
		continue_button.text = "Finish Game"
	else:
		continue_button.text = "Continue"


func calculate_grade() -> String:
	if GameData.accidents == 0 and GameData.average_waiting_time < 15:
		return "A"

	elif GameData.accidents <= 2 and GameData.average_waiting_time < 30:
		return "B"

	elif GameData.accidents <= 4:
		return "C"

	else:
		return "D"


func _on_continue_button_pressed() -> void:
	if GameData.day >= 7:
		get_tree().change_scene_to_file(
            "res://scne/main_menu.tscn"
		)
		return

	GameData.day += 1

	GameData.reset_shift_stats()

	get_tree().change_scene_to_file(
        "res://scne/test_one.tscn"
	)
