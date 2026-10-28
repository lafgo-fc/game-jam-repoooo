extends Control

@onready var npc_died = $npc_died
@onready var reputation = $reputation

func show_label():
	npc_died.show()
	reputation.show()
func hide_label():
	npc_died.hide()
	reputation.hide()
