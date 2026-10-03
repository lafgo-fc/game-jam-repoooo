extends CharacterBody2D

@onready var npc_1 = $"npc 1"
@onready var traffic_light = $"."
@onready var npc_2 = $"npc 2"
@onready var npc_3 =  $"npc 3"
@onready var npc_4 = $"npc 4"
@onready var npc_5 = $"npc 5"
@onready var npc_6 = $"npc 6"
var near_pt : Marker2D
var last_direction : String
var npc_inside : bool = false
var npc_name : AnimatedSprite2D
var npc_list : Array[AnimatedSprite2D]

const SPEED = 30.0

var reached_near_pt = false
func _ready():
	add_to_group("npc")
	npc_list = [npc_1,npc_2,npc_3,npc_4,npc_5,npc_6]
	npc_name = npc_list.pick_random()
	for npc in npc_list:
		npc.hide()
	npc_name.show()

func _physics_process(delta: float) -> void:
	if near_pt == null:
		return

	if reached_near_pt:
		velocity = Vector2.ZERO
		return

	var distance = global_position.distance_to(near_pt.global_position)
	var direction = global_position.direction_to(near_pt.global_position)

	if distance < 8.0 or npc_inside == true:
		reached_near_pt = true
		velocity = Vector2.ZERO
		npc_name.play("idle " + last_direction)
		return

	velocity = direction * SPEED
	move_and_slide()

	process_animation(direction)


func process_animation(direction: Vector2):
	if abs(direction.x)>abs(direction.y):
		if direction.x > 0:
			npc_name.play("right")
			last_direction = "right"
		else :
			npc_name.play("left")
			last_direction = "left"
	else:
		if direction.y > 0:
			npc_name.play("front")
			last_direction = "front"
		else :
			npc_name.play("top")
			last_direction = "top"



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and body.is_in_group("npc"):
		print("npc")
		npc_inside = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != self and body.is_in_group("npc"):
		npc_inside = false
