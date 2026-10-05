extends CharacterBody2D
#sctipts and scenes import
@onready var npc_1 = $"npc 1"
@onready var traffic_light = $"../../TrafficLight"
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
var stop_signal : bool
var previous_pt : Marker2D
var different_directional_npc : bool 
var other_npc : Node2D = null
var avoiding: bool = false
var avoid_time : float = 0
var daycycle : String

# constants
const SPEED = 30.0
const avoid_duration = 0.8
const avoid_strength = 80


func _ready():
	add_to_group("npc")
	npc_list = [npc_1,npc_2,npc_3,npc_4,npc_5,npc_6]
	npc_name = npc_list.pick_random()
	for npc in npc_list:
		npc.hide()
	npc_name.show()

func _physics_process(delta: float) -> void:
	print(avoiding)
	if near_pt == null:
		return

	if different_directional_npc and other_npc != null and not avoiding:
		avoiding = true
		avoid_time = 0.0
	else :
		avoiding = false

	if avoiding:

		var direction = global_position.direction_to(near_pt.global_position)

		if (last_direction == "right" and other_npc.last_direction == "left"):

			velocity.x = direction.x * SPEED
			velocity.y = 80
		elif last_direction == "left" and other_npc.last_direction == "right":
			velocity.x = direction.x * SPEED
			velocity.y = -80
		elif last_direction == "top" and other_npc.last_direction == "front":
			velocity.y = direction.y * SPEED
			velocity.x = 80

		elif last_direction == "front" and other_npc.last_direction == "top":
			velocity.y = direction.y * SPEED
			velocity.x = -80
		move_and_slide()

		return

		
		
	var distance = global_position.distance_to(near_pt.global_position)
	var direction = global_position.direction_to(near_pt.global_position)
	if distance < 5.0:	
		nex_pt()
		return
	check_signal()
	if npc_inside == true or stop_signal == true:
		velocity = Vector2.ZERO
		npc_name.play("idle " + last_direction)
	else:
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
	previous_pt = near_pt
	if near_pt == pt_1:
		var possible_pt = [pt_3 , pt_2 , pt_8]
		near_pt = possible_pt.pick_random()
	elif near_pt == pt_2:
		var possible_pt = [pt_6]
		near_pt = possible_pt.pick_random()

	elif near_pt == pt_3:
		var possible_pt = [pt_4,pt_7,pt_11,pt_1]
		near_pt = possible_pt.pick_random()

	elif near_pt == pt_4:
		var possible_pt = [pt_9,pt_3,pt_2]
		near_pt = possible_pt.pick_random()
func  check_signal():
	stop_signal = false

	# pt1 → pt3
	if previous_pt == pt_1 and near_pt == pt_3:
		if GameData.light == "red in right" or GameData.light == "green in front":
			stop_signal = true

	# pt2 → pt4
	elif previous_pt == pt_2 and near_pt == pt_4:
		if GameData.light == "red in right" or GameData.light == "green in front":
			stop_signal = true

	# pt3 → pt1
	elif previous_pt == pt_3 and near_pt == pt_1:
		if GameData.light == "red in right" or GameData.light == "green in front":
			stop_signal = true

	# pt4 → pt2
	elif previous_pt == pt_4 and near_pt == pt_2:
		if GameData.light == "red in right" or GameData.light == "green in front":
			stop_signal = true
	# pt2 → pt1
	elif previous_pt == pt_2 and near_pt == pt_1:
		if GameData.light == "red in front" or GameData.light == "green in right":
			stop_signal = true
	# pt1 → pt2
	elif previous_pt == pt_1 and near_pt == pt_2:
		if GameData.light == "red in front" or GameData.light == "green in right":
			stop_signal = true
	# pt4 → pt3
	elif previous_pt == pt_4 and near_pt == pt_3:
		if GameData.light == "red in front" or GameData.light == "green in right":
			stop_signal = true
	# pt3 → pt4
	elif previous_pt == pt_3 and near_pt == pt_4:
		if GameData.light == "red in front" or GameData.light == "green in right":
			stop_signal = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and body.is_in_group("npc"):
		other_npc = body
		different_directional_npc = false
		if last_direction == body.last_direction:
			npc_inside = true
		else :
			different_directional_npc = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != self and body.is_in_group("npc"):
		npc_inside = false
func timer_updates():
	if daycycle == "morning":
		print("fcking morning")
	elif daycycle == "afternoon":
		print("fcking afternoon")
	elif daycycle == "night":
		print("fcking night")
		
