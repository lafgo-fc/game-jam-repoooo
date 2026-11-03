extends Node2D

@export var npc: PackedScene
@export var near_pt: Marker2D


@onready var timer = $spawn_Timer
var can_spawn = true
func _ready() -> void:
	timer.start()
	spawn_npc()


func spawn_npc() -> void:
	if npc == null:
		return

	if near_pt == null:
		return

	var npc_spawn = npc.instantiate()
	npc_spawn.npc_id = GameData.get_next_npc_id()
	add_child(npc_spawn)
	npc_spawn.global_position = global_position
	npc_spawn.near_pt = near_pt
func manage_npc_timer():
	if GameData.daycycle == "morning":
		timer.wait_time(30)
	elif GameData.daycycle == "afternoon":
		timer.wait_time(25)
	elif GameData.daycycle == "evening":
		timer.wait_time(20)


func _on_timer_timeout() -> void:
	if can_spawn:
		spawn_npc()


func spawner_time(new_time: float) -> void:
	timer.wait_time = new_time
	timer.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("npc"):
		can_spawn = false


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("npc"):
		can_spawn = true
