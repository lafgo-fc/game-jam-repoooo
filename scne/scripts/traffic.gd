extends CharacterBody2D
@onready var red_light = $red
@onready var green_light = $green
var light : String = "red"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("traffic control"):
		if light=="red":
			light = "green"
		else:
			light = "red"
		GameData.traffic = !GameData.traffic
	_light_color()

func _light_color() -> void:
	if light == "red":
		red_light.show()
		green_light.hide()
	elif light == "green":
		green_light.show()
		red_light.hide()
