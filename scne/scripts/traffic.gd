extends CharacterBody2D
@onready var red_light_front_back = $"traffic light front back/red"
@onready var red_light_right = $"traffic light left/red right"
@onready var green_light_front_back = $"traffic light front back/green"
@onready var green_light_left = $"traffic light left/green left"
@onready var red_light_left = $"traffic light left/red left"
@onready var green_light_right = $"traffic light left/green right"
var light : String = "red in front"

var direction_signal : String = "left"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("traffic control front and back"):
		if light == "red in front":
			light = "green in front"
		else:
			light = "red in front"

	GameData.traffic = light == "green in front"
	if Input.is_action_just_pressed("traffic control right and left"):
		if light == "red in right":
			light = "green in right"
		else:
			light = "red in right"

	GameData.traffic = light == "green in right"
	_light_color()

func _light_color():
	if light == "red in front":
		red_light_front_back.show()
		green_light_front_back.hide()

	elif light == "green in front":
		green_light_front_back.show()
		red_light_front_back.hide()
	elif light == "green in right":
		green_light_left.show()
		green_light_right.show()
		red_light_right.hide()
		red_light_left.hide()
	elif light == "red in right":
		red_light_left.show()
		red_light_right.show()
		green_light_right.hide()
		green_light_left.hide()
