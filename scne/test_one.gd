extends Node2D
@onready var day_timer = $daytime     # import the day-night timer
@onready var surroundings = $"day-night manager"
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
	day_timer.start(500)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(GameData.daycycle)
	time_op()
	if GameData.daycycle == "morning":
		surroundings.color = Color(1,0.9,0.8)
	elif GameData.daycycle == "afternoon":
		surroundings.color = Color(1,1,1)
	elif GameData.daycycle == "evening":
		surroundings.color = Color(1,0.7,0.5)
	elif GameData.daycycle == "night":
		surroundings.color = Color(0.25,0.3,0.5)
