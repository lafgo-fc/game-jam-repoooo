extends CharacterBody2D
@onready var red_light_front_back = $"traffic light front back/red"
@onready var red_light_right = $"traffic light left/red right"
@onready var green_light_front_back = $"traffic light front back/green"
@onready var green_light_left = $"traffic light left/green left"
@onready var red_light_left = $"traffic light left/red left"
@onready var green_light_right = $"traffic light left/green right"
@onready var car_direction = $"."
var light : String = "red in front"
func car_pass():
	if light == "green in right" or light == "red in front":
		GameData.traffic_right_left = true
	else :
		GameData.traffic_right_left = false
	if light == "green in front" or light == "red in right":
		GameData.traffic_front_down = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("traffic control front and back"):
		if light == "red in front":
			light = "green in front"
		else:
			light = "red in front"
	if Input.is_action_just_pressed("traffic control right and left"):
		if light == "red in right":
			light = "green in right"
		else:
			light = "red in right"
	_light_color()
	car_pass()
	if Input.is_action_just_pressed("stop all"):
		light = "all red"
	

func _light_color():
	if light == "red in front":
		red_light_front_back.show()
		green_light_front_back.hide()
		green_light_right.show()
		green_light_left.show()

	elif light == "green in front":
		green_light_front_back.show()
		red_light_front_back.hide()
		green_light_left.hide()
		green_light_right.hide()
		red_light_left.show()
		red_light_right.show()
	elif light == "green in right":
		green_light_left.show()
		green_light_right.show()
		red_light_right.hide()
		red_light_left.hide()
		green_light_front_back.hide()
		red_light_front_back.show()
	elif light == "red in right":
		red_light_left.show()
		red_light_right.show()
		green_light_right.hide()
		green_light_left.hide()
		green_light_front_back.show()
		red_light_front_back.hide()
	elif light == "all red":
		green_light_left.hide()
		green_light_right.hide()
		red_light_right.show()
		red_light_left.show()
		green_light_front_back.hide()
		red_light_front_back.show()
