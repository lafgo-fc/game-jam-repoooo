extends Control
@onready var bg_music : AudioStreamPlayer2D = $"BG MUSIC"
@onready var start_click : AudioStreamPlayer2D = $"start click"
@onready var exit_click : AudioStreamPlayer2D = $"exit click"
@onready var hover_effect : AudioStreamPlayer2D = $"hover sound"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_music.finished.connect(bg_music.play)
	bg_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	start_click.play()


func _on_button_4_pressed() -> void:
	exit_click.play()


func _on_button_3_pressed() -> void:
	start_click.play()
	Loading.change_scene_to("res://credits.tscn")


func _on_button_mouse_entered() -> void:
	hover_effect.play()


func _on_button_3_mouse_entered() -> void:
	hover_effect.play()


func _on_button_4_mouse_entered() -> void:
	hover_effect.play()
