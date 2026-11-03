extends Node2D
@onready var day_timer = $daytime     # import the day-night timer
@onready var surroundings = $"day-night manager"
@onready var clock = $clock

# adding the npc_spawners

# adding the npc_spawners
@onready var spawner_1: Node2D = $"npc spawners/NpcSpawner"
@onready var spawner_2: Node2D = $"npc spawners/NpcSpawner2"
@onready var spawner_3: Node2D = $"npc spawners/NpcSpawner3"
@onready var spawner_4: Node2D = $"npc spawners/NpcSpawner4"
@onready var car_spawner_1: Node2D = $"car spawner/west/spawnr thing"
@onready var car_spawner_2: Node2D = $"car spawner/north/spawnr thing2"
@onready var car_spawner_3: Node2D = $"car spawner/south/spawnr thing3"
@onready var car_spawner_4: Node2D = $"car spawner/east/spawnr thing4"


# adding the colors
var morning_color = Color(1,0.9,0.8)
var afternoon_color = Color(1,1,1)
var evening_color = Color(1,0.7,0.5)
var night_color = Color(0.25,0.3,0.5)
var min : int 
var hour : int 
var is_cycle_changing : bool = false
var last_daycycle = ""
var day_completed : int = 0
 # this gives us the time we have spent in the day
func time_op():
	
	var time_spent = 1440  - day_timer.time_left 
	if time_spent >= 1439:
		time_spent = 0
		hour = 0 
		min = 0
	elif time_spent >= 721 and time_spent <= 1080 :
		GameData.daycycle = "afternoon"
	elif time_spent >= 1081 and time_spent <= 1200 :
		GameData.daycycle = "evening"
	elif time_spent >= 361 and time_spent <= 720:
		GameData.daycycle = "morning"
		


func _ready() -> void:
	day_timer.wait_time = 1140
	day_timer.start(310)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	end_day_report()
	var target_color : Color
	time_op()
	check_daycycle_changes()
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
	var total_min = int(time_spent) % 1440
	hour =  total_min / 60
	min = total_min % 60
	clock.text = "%02d:%02d" % [hour, min]

func check_daycycle_changes():
	if GameData.daycycle != last_daycycle:
		is_cycle_changing = true
		last_daycycle = GameData.daycycle
	else:
		is_cycle_changing = false
func end_day_report():
	if day_timer.time_left <= 300:
		day_completed += 1
		day_timer.start()
		print(day_completed)
