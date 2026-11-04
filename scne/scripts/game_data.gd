
extends Node

var daycycle: String = ""

var traffic_right_left: bool = false
var traffic_front_down: bool = false

var car_pos: Vector2
var light: String = "red in front"

var reputation: int = 0
var npc_collided: bool = false

# NPC collision tracking
var collided_npc_id: int = -1
var next_npc_id: int = 1

# Car and waiting-time statistics
var car_passed: int = 0
var total_waiting_time: int = 0.0
var total_cars: int = 0
var average_car_waiting_time: float = 0.0
var day_ended = false
var npc_waiting_time = 0.0
var car_waiting_time = 0.0
var npc_passed : int = 0
var avg_npc_waiting : float = 0.0
var car_moving = true


# Seven-day progression
var day: int = 1
var current_shift: String = "Morning"
var accidents: int = 0


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	total_waiting_time = average_car_waiting_time + avg_npc_waiting

func get_next_npc_id() -> int:
	var id: int = next_npc_id
	next_npc_id += 1
	return id


func reset_shift_stats() -> void:
	car_passed = 0
	total_waiting_time = 0.0
	total_cars = 0
	average_car_waiting_time = 0.0
	avg_npc_waiting = 0.0
	accidents = 0
