extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func death_label_show() -> void:
	show()
	modulate.a = 0.0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	tween.tween_interval(1.5)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback(hide)
