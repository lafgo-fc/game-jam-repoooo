extends AnimatedSprite2D
@onready var death_label = $Control4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death_label.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func show_death_label() -> void:
	death_label.show()
func hide_death_label() -> void:
	death_label.hide()
