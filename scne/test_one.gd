extends Node2D
@onready var day_timer = $daytime     # import the day-night timer

# gives the signal of time
func time_op():
	var time_spent = 1440  - day_timer.time_left  # this gives us the time we have spent in the day
	if time_spent <= 360:
		GameData.daycycle = "morning"
	elif time_spent <= 600 :
		GameData.daycycle = "afternooon"
	elif time_spent <= 780 :
		GameData.daycycle = "evening"
	elif time_spent <= 1440:
		GameData.daycycle = "night"

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_op()
