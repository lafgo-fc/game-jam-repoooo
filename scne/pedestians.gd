extends CharacterBody2D

@onready var animation = $"npc 1"
@onready var traffic_light = $"."

@export var p1: Marker2D
@export var p2: Marker2D
@export var p3: Marker2D
@export var p4: Marker2D
@export var p5: Marker2D
@export var p6: Marker2D
@export var p7: Marker2D
@export var p8: Marker2D
@export var p9: Marker2D
@export var p10: Marker2D
@export var p11: Marker2D
var last_direction : String

const SPEED = 30.0

var reached_p1 = false
func _ready():
	add_to_group("npc")

func _physics_process(delta: float) -> void:
	if p1 == null:
		return

	if reached_p1:
		velocity = Vector2.ZERO
		return

	var distance = global_position.distance_to(p1.global_position)
	var direction = global_position.direction_to(p1.global_position)

	if distance < 8.0:
		reached_p1 = true
		velocity = Vector2.ZERO
		animation.play("idle " + last_direction)
		return

	velocity = direction * SPEED
	move_and_slide()

	process_animation(direction)


func process_animation(direction: Vector2):
	if direction.x > 0:
		animation.play("right")
		last_direction = "right"
	elif direction.x < 0:
		animation.play("left")
	elif direction.y > 0:
		animation.play("top")
	elif direction.y < 0 :
		animation.play("front")





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and body.is_in_group("npc"):
		print("npc")
