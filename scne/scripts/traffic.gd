extends CharacterBody2D
@onready var red_light_front_back = $"traffic light front back/red"
@onready var red_light_left = $"traffic light left/red3"
@onready var red_light_right = $"traffic light right/red2"
@onready var green_light_front_back = $"traffic light front back/green"
@onready var green_light_left = $"traffic light left/green2"
@onready var green_light_right = $"traffic light right/green3"
var light : String = "red"

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
		red_light_front_back.show()
		green_light_front_back.hide()

	elif light == "green":
		green_light_front_back.show()
		red_light_front_back.hide()
