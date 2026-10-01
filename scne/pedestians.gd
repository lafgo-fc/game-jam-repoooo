extends CharacterBody2D
@onready var animation = $"cap guy"
var p1: Marker2D
const SPEED = 30.0

func _physics_process(delta: float) -> void:
	if p1 == null:
		return

	var direction = global_position.direction_to(p1.global_position)

	velocity = direction * SPEED
	move_and_slide()

	process_animation(direction)
	
func process_animation(direction : Vector2):
	if direction.x > 0:
		animation.play("right")
		
