extends Node
var daycycle : String
var traffic_right_left = false 
var traffic_front_down = false 
var car_pos : Vector2
var light : String = "red in front"
var reputation : int = 0
var npc_collided:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
var next_npc_id : int = 1
func get_next_npc_id() -> int:
	var id  = next_npc_id
	next_npc_id += 1
	return id
