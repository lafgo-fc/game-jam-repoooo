extends Node2D
@export var npc : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_npc()
func spawn_npc():
	var npc_spawn = npc.instantiate()
	add_child(npc_spawn)
	npc_spawn.global_position = global_position



func _on_timer_timeout() -> void:
	spawn_npc()
