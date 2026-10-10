extends Node2D
@onready var day_timer = $daytime     # import the day-night timer
@onready var surroundings = $"day-night manager"
@onready var clock = $clock

# adding the npc_spawners
@onready var  spawner_1 = $NpcSpawner
@onready var spawner_2 = $NpcSpawner2
@onready var spawner_3 = $NpcSpawner3
@onready var spawner_4 = $NpcSpawner4

# adding the colors
var morning_color = Color(1,0.9,0.8)
var afternoon_color = Color(1,1,1)
var evening_color = Color(1,0.7,0.5)
var night_color = Color(0.25,0.3,0.5)
var min : int 
var hour : int 
var is_cycle_changing : bool = false
var last_daycycle = ""
 # this gives us the time we have spent in the day
func time_op():
	
	var time_spent = 1440  - day_timer.time_left 
	print("Time left: ", day_timer.time_left)
	print("Wait time: ", day_timer.wait_time)
	if time_spent >= 1439:
		time_spent = 0
		hour = 0 
		min = 0
	if time_spent <= 360 or  time_spent >=1201 :
		GameData.daycycle = "night"
	elif time_spent >= 721 and time_spent <= 1080 :
		GameData.daycycle = "afternoon"
	elif time_spent >= 1081 and time_spent <= 1200 :
		GameData.daycycle = "evening"
	elif time_spent >= 361 and time_spent <= 720:
		GameData.daycycle = "morning"
		


func _ready() -> void:
	day_timer.wait_time = 1440
	day_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_color : Color
	time_op()
	check_daycycle_changes()
	clock_time()
	if GameData.daycycle == "morning":
		target_color = morning_color
	elif GameData.daycycle == "afternoon":
		target_color = afternoon_color
		manage_traffic()
	elif GameData.daycycle == "evening":
		target_color = evening_color
		manage_traffic()
	elif GameData.daycycle == "night":
		target_color = night_color
		manage_traffic()
	surroundings.color = surroundings.color.lerp(target_color,delta*0.5)

func clock_time():
	var time_spent = 1440  - day_timer.time_left 
	var total_min = int(time_spent) % 1440
	hour =  total_min / 60
	min = total_min % 60
	clock.text = "%02d:%02d" % [hour, min]
func manage_traffic():
	if GameData.daycycle == "morning" and is_cycle_changing:
		spawner_1.spawner_time(25)
		spawner_2.spawner_time(35)
		spawner_3.spawner_time(30)
		spawner_4.spawner_time(20)
	elif GameData.daycycle == "afternoon":
		spawner_1.spawner_time(20)
		spawner_2.spawner_time(25)
		spawner_3.spawner_time(15)
		spawner_4.spawner_time(30)
	elif GameData.daycycle == "evening":
		spawner_1.spawner_time(10)
		spawner_2.spawner_time(15)
		spawner_3.spawner_time(8)
		spawner_4.spawner_time(10)
	elif GameData.daycycle == "night":
		spawner_1.spawner_time(30)
		spawner_2.spawner_time(35)
		spawner_3.spawner_time(40)
		spawner_4.spawner_time(30)

func check_daycycle_changes():
	if GameData.daycycle != last_daycycle:
		is_cycle_changing = true
		GameData.daycycle = last_daycycle
	else:
		is_cycle_changing = false
