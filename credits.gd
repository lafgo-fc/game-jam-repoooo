extends Control

@onready var bg_music : AudioStreamPlayer2D = $"BG MUSIC"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Loading.change_scene_to("res://main_menu.tscn")
