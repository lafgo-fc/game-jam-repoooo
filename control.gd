extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func show_death_label(npc_id : int ) -> void:
	$VBoxContainer/Label.text = "NPC ID" + str(npc_id)
	$VBoxContainer/Label2.text= "NPC ID" + str(npc_id)
	$VBoxContainer/Label.show()
	$VBoxContainer/Label2.show()
