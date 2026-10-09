extends Node2D

@export var npc: PackedScene
@export var near_pt: Marker2D
@export var spawn_time : float = 3.0
@onready var timer = $Timer
# importing spawners



func _ready() -> void:
	timer.wait_time = spawn_time
	timer.start()
	spawn_npc()

func spawn_npc():
	if npc == null:
		print("NPC scene not assigned")
		return
	if near_pt == null:
		return

	var npc_spawn = npc.instantiate()
	add_child(npc_spawn)

	npc_spawn.global_position = global_position
	npc_spawn.near_pt = near_pt

func _on_timer_timeout() -> void:
	spawn_npc()

# managinig traffic accorging to the time

		
