extends CharacterBody2D
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
		print("red")
	elif light == "green":
		print("green")
