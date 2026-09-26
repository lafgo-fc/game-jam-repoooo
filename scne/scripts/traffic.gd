extends CharacterBody2D
@onready var red_light = $"traffic light front/red"
@onready var green_light = $"traffic light front/green"
@onready var timer = $Timer
var light : String = "red"
var timer_stopped : bool =  false
var direction_signal : String = "left"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("traffic control front"):
		if light == "red":
			light = "green"
		else:
			light = "red"

	GameData.traffic = light == "green"
	_light_color()

func _light_color():
	if light == "red":
		red_light.show()
		green_light.hide()

		if timer.is_stopped():
			timer.start(3.0)
			await timer.timeout
			light = "green"

	elif light == "green":
		green_light.show()
		red_light.hide()

		if timer.is_stopped():
			timer.start(3.0)
			await timer.timeout
			light = "red"
