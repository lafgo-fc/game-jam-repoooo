
extends Node2D

@onready var day_timer = $daytime
@onready var surroundings = $"day-night manager"
@onready var clock = $clock

# NPC spawners
@onready var spawner_1: Node2D = $"npc spawners/NpcSpawner"
@onready var spawner_2: Node2D = $"npc spawners/NpcSpawner2"
@onready var spawner_3: Node2D = $"npc spawners/NpcSpawner3"
@onready var spawner_4: Node2D = $"npc spawners/NpcSpawner4"

@onready var car_spawner_1: Node2D = $"car spawner/west/spawnr thing"
@onready var car_spawner_2: Node2D = $"car spawner/north/spawnr thing2"
@onready var car_spawner_3: Node2D = $"car spawner/south/spawnr thing3"
@onready var car_spawner_4: Node2D = $"car spawner/east/spawnr thing4"
@onready var morning_label = $morning
@onready var afternoon_label = $afternoon
@onready var evening_label = $evening

@onready var siren: AudioStreamPlayer2D = $sounds/siren
@onready var bg_music: AudioStreamPlayer2D = $"sounds/bg music"

# Colors
var morning_color = Color(1, 0.9, 0.8)
var afternoon_color = Color(1, 1, 1)
var evening_color = Color(1, 0.7, 0.5)
var night_color = Color(0.25, 0.3, 0.5)

var min: int
var hour: int

var is_cycle_changing: bool = false
var last_daycycle: String = ""

var day_ended: bool = false

# Report system
var day_completed: int = 0
var report_generated: bool = false


func _ready() -> void:
	bg_music.finished.connect(bg_music.play)
	bg_music.play()

	print("TEST_ONE READY")
	print("SIREN: ", siren)

	day_timer.wait_time = 1440
	day_timer.one_shot = true
	day_timer.start()

	# Friend's timer setting
	day_timer.wait_time = 1140
	day_timer.start(1000)


func _process(delta: float) -> void:
	end_day_report()

	var target_color: Color

	time_op()
	check_daycycle_changes()
	manage_traffic()
	clock_time()
	control_sound()

	if GameData.daycycle == "morning":
		target_color = morning_color
		morning_label.show()
		afternoon_label.hide()
		evening_label.hide()
	elif GameData.daycycle == "afternoon":
		target_color = afternoon_color
		morning_label.hide()
		afternoon_label.show()
		evening_label.hide()
	elif GameData.daycycle == "evening":
		target_color = evening_color
		morning_label.hide()
		afternoon_label.hide()
		evening_label.show()
	else:
		target_color = night_color

	surroundings.color = surroundings.color.lerp(
		target_color,
		delta * 0.5
	)


func time_op() -> void:
	var time_spent = 1440 - day_timer.time_left

	if time_spent >= 1439:
		time_spent = 0
		hour = 0
		min = 0

	if time_spent <= 360 or time_spent >= 1201:
		GameData.daycycle = "night"
	elif time_spent >= 721 and time_spent <= 1080:
		GameData.daycycle = "afternoon"
	elif time_spent >= 1081 and time_spent <= 1200:
		GameData.daycycle = "evening"
	elif time_spent >= 361 and time_spent <= 720:
		GameData.daycycle = "morning"


func clock_time() -> void:
	var time_spent = 1440 - day_timer.time_left
	var total_min = int(time_spent) % 1440

	hour = total_min / 60
	min = total_min % 60

	clock.text = "%02d:%02d" % [hour, min]


func manage_traffic() -> void:
	if GameData.daycycle == "morning" and is_cycle_changing:
		spawner_1.spawner_time(25)
		spawner_2.spawner_time(35)
		spawner_3.spawner_time(30)
		spawner_4.spawner_time(20)

	elif GameData.daycycle == "afternoon" and is_cycle_changing:
		spawner_1.spawner_time(20)
		spawner_2.spawner_time(25)
		spawner_3.spawner_time(15)
		spawner_4.spawner_time(30)

	elif GameData.daycycle == "evening" and is_cycle_changing:
		spawner_1.spawner_time(10)
		spawner_2.spawner_time(15)
		spawner_3.spawner_time(8)
		spawner_4.spawner_time(10)

	elif GameData.daycycle == "night" and is_cycle_changing:
		spawner_1.spawner_time(30)
		spawner_2.spawner_time(35)
		spawner_3.spawner_time(40)
		spawner_4.spawner_time(30)


func check_daycycle_changes() -> void:
	if GameData.daycycle != last_daycycle:
		is_cycle_changing = true
		last_daycycle = GameData.daycycle
	else:
		is_cycle_changing = false


func end_day_report() -> void:
	if day_timer.time_left <= 300 and not report_generated:
		report_generated = true
		day_completed += 1
		day_timer.stop()

		print("ran")
		print(day_completed, " day completed")
		print("Total number of npc died ", GameData.accidents)
		print("Total waiting time of car ", GameData.average_car_waiting_time)
		print("Total waiting time of npc ", GameData.avg_npc_waiting)
		print("total cars passed ", GameData.total_cars)
		print("avg waiting time of car ", GameData.total_waiting_time)

		GameData.npc_waiting_time = 0
		GameData.car_waiting_time = 0

		get_tree().change_scene_to_file("res://report.tscn")


func control_sound() -> void:
	if not is_instance_valid(siren):
		print("Siren node is not ready!")
		return

	if GameData.emergency_vehicle > 0:
		if not siren.playing:
			siren.play()
	else:
		siren.stop()
