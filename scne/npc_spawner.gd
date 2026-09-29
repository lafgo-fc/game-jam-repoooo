extends Node2D

@export var npc: PackedScene
@onready var p1 = $"../waypoints/p1"

func _ready() -> void:
	spawn_npc()

func spawn_npc():
	if npc == null:
		print("NPC scene not assigned")
		return

	var npc_spawn = npc.instantiate()
	add_child(npc_spawn)

	npc_spawn.global_position = global_position
	npc_spawn.p1 = p1

func _on_timer_timeout() -> void:
	spawn_npc()
