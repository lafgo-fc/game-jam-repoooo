extends CharacterBody2D
#sctipts and scenes import
@onready var npc_1 = $"npc 1"
@onready var traffic_light = $"."
@onready var npc_2 = $"npc 2"
@onready var npc_3 =  $"npc 3"
@onready var npc_4 = $"npc 4"
@onready var npc_5 = $"npc 5"
@onready var npc_6 = $"npc 6"


# adding markers
@onready var pt_1 = $"../../waypoints/p1"
@onready var pt_2 = $"../../waypoints/p2"
@onready var pt_3 = $"../../waypoints/p3"
@onready var pt_4 = $"../../waypoints/p4"
@onready var pt_5 = $"../../waypoints/p5"
@onready var pt_6 = $"../../waypoints/p6"
@onready var pt_7 = $"../../waypoints/p7"
@onready var pt_8 = $"../../waypoints/p8"
@onready var pt_9 = $"../../waypoints/p9"
@onready var pt_10 = $"../../waypoints/p10"
@onready var pt_11 = $"../../waypoints/p11"

# essential vars
var near_pt : Marker2D
var last_direction : String
var npc_inside : bool = false
var npc_name : AnimatedSprite2D
var npc_list : Array[AnimatedSprite2D]

const SPEED = 30.0


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

	var distance = global_position.distance_to(near_pt.global_position)
	var direction = global_position.direction_to(near_pt.global_position)
	if distance < 5.0:
		nex_pt()
		return
	if npc_inside == true:
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

# here we are checking our next pt
func nex_pt():
	print("nex_pt called")
	print("near pt " , near_pt)
	print("pt_1 ", pt_1)
	if near_pt == pt_1:
		print("npc reached")
		var possible_pt = [pt_3,pt_8 , pt_2 ]
		near_pt = possible_pt.pick_random()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and body.is_in_group("npc"):
		print("npc")
		npc_inside = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != self and body.is_in_group("npc"):
		npc_inside = false
