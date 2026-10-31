
extends Node

var daycycle: String
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
var total_waiting_time: float = 0.0
var total_cars: int = 0
var average_waiting_time: float = 0.0
var day_ended = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func get_next_npc_id() -> int:
	var id: int = next_npc_id
	next_npc_id += 1
	return id
