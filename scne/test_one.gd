extends Node2D
@onready var day_timer = $daytime     # import the day-night timer
@onready var surroundings = $"day-night manager"
@onready var clock = $clock
# gives the signal of time

# adding the colors
var morning_color = Color(1,0.9,0.8)
var afternoon_color = Color(1,1,1)
var evening_color = Color(1,0.7,0.5)
var night_color = Color(0.25,0.3,0.5)
var min : int 
var hour : int 
 # this gives us the time we have spent in the day
func time_op():
	var time_spent = 1440  - day_timer.time_left 
	clock.text = str(hour , ":", min)
	if time_spent <= 360:
		GameData.daycycle = "morning"
	elif time_spent <= 600 :
		GameData.daycycle = "afternoon"
	elif time_spent <= 780 :
		GameData.daycycle = "evening"
	elif time_spent <= 1440:
		GameData.daycycle = "night"
		


func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_color : Color
	time_op()
	clock_time()
	if GameData.daycycle == "morning":
		target_color = morning_color
	elif GameData.daycycle == "afternoon":
		target_color = afternoon_color
	elif GameData.daycycle == "evening":
		target_color = evening_color
	elif GameData.daycycle == "night":
		target_color = night_color
	surroundings.color = surroundings.color.lerp(target_color,delta*0.5)

func clock_time():
	var time_spent = 1440  - day_timer.time_left 
	var total_min = int(time_spent)
	hour = 6 + total_min / 60
	min = total_min % 60
	print(hour , ":" , min)
