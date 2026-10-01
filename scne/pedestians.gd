extends CharacterBody2D

@onready var animation = $"cap guy"

@export var p1: Marker2D

const SPEED = 30.0

func _physics_process(delta: float) -> void:
	print(p1)



	if p1 == null:
		return
	var distance = global_position.distance_to(p1.global_position)
	var direction = global_position.direction_to(p1.global_position)
	if distance < 5.0:
		velocity = Vector2.ZERO
		animation.play("idle")
		return



	velocity = direction * SPEED
	move_and_slide()

	process_animation(direction)


func process_animation(direction: Vector2):
	if direction.x > 0:
		animation.play("right")
	if direction.x < 0:
		animation.play("left")
		
