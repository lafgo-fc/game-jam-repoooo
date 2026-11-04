extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

var scene_to_load: String
var colourrect_tween: Tween


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 128

	color_rect.visible = true
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	color_rect.z_index = 4096
	color_rect.color = Color.BLACK
	color_rect.self_modulate = Color(1, 1, 1, 0)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE


func change_scene_to(scene_path: String) -> void:
	scene_to_load = scene_path

	if colourrect_tween:
		colourrect_tween.kill()

	color_rect.self_modulate.a = 0.0

	colourrect_tween = create_tween()
	colourrect_tween.set_trans(Tween.TRANS_SINE)
	colourrect_tween.set_ease(Tween.EASE_IN_OUT)

	colourrect_tween.tween_property(
		color_rect, "self_modulate:a", 1.0, 2.0
	)

	await colourrect_tween.finished

	var error = get_tree().change_scene_to_file(scene_to_load)

	if error != OK:
		print("Scene loading error: ", error)
		return

	await get_tree().process_frame

	colourrect_tween = create_tween()
	colourrect_tween.set_trans(Tween.TRANS_SINE)
	colourrect_tween.set_ease(Tween.EASE_IN_OUT)

	colourrect_tween.tween_property(
		color_rect, "self_modulate:a", 0.0, 2.0
	)

	
