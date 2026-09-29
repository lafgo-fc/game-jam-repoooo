extends Node2D
@onready var npc = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_npc()
func spawn_npc():
	var npc_spawn = npc.instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
