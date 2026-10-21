extends CharacterBody2D

# scripts and scenes import
@onready var npc_1 = $"npc 1"
@onready var traffic_light = $"../../TrafficLight"
@onready var npc_2 = $"npc 2"
@onready var npc_3 = $"npc 3"
@onready var npc_4 = $"npc 4"
@onready var npc_5 = $"npc 5"
@onready var npc_6 = $"npc 6"
@onready var light = $PointLight2D
@onready var death_label = get_tree().current_scene.get_node("death_label")


# adding markers
@onready var pt_1 = $"npc spawners/waypoints/p1"
@onready var pt_2 = $"npc spawners/waypoints/p2"
@onready var pt_3 = $"npc spawners/waypoints/p3"
@onready var pt_4 = $"npc spawners/waypoints/p4"
@onready var pt_5 = $"npc spawners/waypoints/p5"
@onready var pt_6 = $"npc spawners/waypoints/p6"
@onready var pt_7 = $"npc spawners/waypoints/p7"
@onready var pt_8 = $"npc spawners/waypoints/p8"
@onready var pt_9 = $"npc spawners/waypoints/p9"
@onready var pt_10 = $"npc spawners/waypoints/p10"
@onready var pt_11 = $"npc spawners/waypoints/p11"

# adding death_labels





# essential vars
var near_pt : Marker2D
var last_direction : String
var npc_inside : bool = false
var npc_name : AnimatedSprite2D
var npc_list : Array[AnimatedSprite2D]

var stop_signal : bool = false
var previous_pt : Marker2D

var different_directional_npc : bool = false
var other_npc : Node2D = null

var avoiding : bool = false
var avoid_time : float = 0.0

var reached_pt : Marker2D
var collided_npc : Node2D = null 
var npc_id: int =-1

# constants
const SPEED = 30.0
const AVOID_DURATION = 0.8
const AVOID_STRENGTH = 80.0


func _ready() -> void:
	add_to_group("npc")

	npc_list = [
		npc_1,
		npc_2,
		npc_3,
		npc_4,
		npc_5,
		npc_6
	]

	npc_name = npc_list.pick_random()

	for npc in npc_list:
		npc.hide()

	npc_name.show()


func _physics_process(delta: float) -> void:

	if near_pt == null:
		return


	
	# START DODGE
	

	if different_directional_npc and other_npc != null and not avoiding:

		# Only one of the two NPCs should dodge.
		# The NPC with the smaller instance ID dodges.
		if get_instance_id() < other_npc.get_instance_id():
			avoiding = true
			avoid_time = 0.0


	# --------------------------------
	# DODGE MOVEMENT
	# --------------------------------

	if avoiding:

		var direction = global_position.direction_to(
			near_pt.global_position
		)

		# Increase dodge timer
		avoid_time += delta

		# Normal forward movement
		var normal_velocity = direction * SPEED

		# Sideways sine-wave movement
		var dodge_offset = dodge_movement(
			direction,
			avoid_time,
			AVOID_STRENGTH
		)

		velocity = normal_velocity + dodge_offset

		move_and_slide()

		# End dodge
		if avoid_time >= AVOID_DURATION:
			avoiding = false
			avoid_time = 0.0

		return
	show_light()
	npc_collision()


	# --------------------------------
	# NORMAL MOVEMENT
	# --------------------------------

	var distance = global_position.distance_to(
		near_pt.global_position
	)

	var direction = global_position.direction_to(
		near_pt.global_position
	)


	# Reached waypoint
	if distance < 5.0:
		print("next pt called")
		reached_pt = near_pt
		nex_pt()
		return


	check_signal()



	# --------------------------------
	# STOP / IDLE
	# --------------------------------

	if npc_inside or stop_signal:

		velocity = Vector2.ZERO
		npc_name.play("idle " + last_direction)

	else:

		velocity = direction * SPEED
		move_and_slide()

		process_animation(direction)


# --------------------------------
# SINE-WAVE DODGE MOVEMENT
# --------------------------------

func dodge_movement(
	direction: Vector2,
	dodge_time: float,
	dodge_amount: float
) -> Vector2:

	var perpendicular = Vector2(
		-direction.y,
		direction.x
	)

	# Convert 0 -> AVOID_DURATION
	# into 0 -> PI so the sine starts and ends at 0.
	var dodge_progress = clamp(
		dodge_time / AVOID_DURATION,
		0.0,
		1.0
	)

	var sine_amount = sin(
		dodge_progress * PI
	)

	var dodge_offset = (
		perpendicular
		* sine_amount
		* dodge_amount
	)

	return dodge_offset


# --------------------------------
# ANIMATION / DIRECTION
# --------------------------------

func process_animation(direction: Vector2) -> void:

	if abs(direction.x) > abs(direction.y):

		if direction.x > 0:
			npc_name.play("right")
			last_direction = "right"

		else:
			npc_name.play("left")
			last_direction = "left"

	else:

		if direction.y > 0:
			npc_name.play("front")
			last_direction = "front"

		else:
			npc_name.play("top")
			last_direction = "top"


# --------------------------------
# NEXT WAYPOINT
# --------------------------------

func nex_pt() -> void:

	previous_pt = near_pt

	if (
		reached_pt == pt_9
		or reached_pt == pt_7
		or reached_pt == pt_8
		or reached_pt == pt_10
		or reached_pt == pt_5
		or reached_pt == pt_6
	):

		queue_free()

		print("reached exit")

		GameData.reputation += 100

		print(GameData.reputation)


	if near_pt == pt_1:

		var possible_pt = [
			pt_3,
			pt_2,
			pt_8
		]

		near_pt = possible_pt.pick_random()


	elif near_pt == pt_2:

		var possible_pt = [
			pt_6,
			pt_10,
			pt_4,
			pt_1
		]

		near_pt = possible_pt.pick_random()


	elif near_pt == pt_3:

		var possible_pt = [
			pt_4,
			pt_7,
			pt_11,
			pt_1
		]

		near_pt = possible_pt.pick_random()


	elif near_pt == pt_4:

		var possible_pt = [
			pt_9,
			pt_3,
			pt_5,
			pt_2
		]

		near_pt = possible_pt.pick_random()


# --------------------------------
# TRAFFIC LIGHT CHECK
# --------------------------------

func check_signal() -> void:

	stop_signal = false


	# pt1 → pt3
	if previous_pt == pt_1 and near_pt == pt_3:

		if GameData.light == "red in right" \
		or GameData.light == "green in front":

			stop_signal = true


	# pt2 → pt4
	elif previous_pt == pt_2 and near_pt == pt_4:

		if GameData.light == "red in right" \
		or GameData.light == "green in front":

			stop_signal = true


	# pt3 → pt1
	elif previous_pt == pt_3 and near_pt == pt_1:

		if GameData.light == "red in right" \
		or GameData.light == "green in front":

			stop_signal = true


	# pt4 → pt2
	elif previous_pt == pt_4 and near_pt == pt_2:

		if GameData.light == "red in right" \
		or GameData.light == "green in front":

			stop_signal = true


	# pt2 → pt1
	elif previous_pt == pt_2 and near_pt == pt_1:

		if GameData.light == "red in front" \
		or GameData.light == "green in right":

			stop_signal = true


	# pt1 → pt2
	elif previous_pt == pt_1 and near_pt == pt_2:

		if GameData.light == "red in front" \
		or GameData.light == "green in right":

			stop_signal = true


	# pt4 → pt3
	elif previous_pt == pt_4 and near_pt == pt_3:

		if GameData.light == "red in front" \
		or GameData.light == "green in right":

			stop_signal = true


	# pt3 → pt4
	elif previous_pt == pt_3 and near_pt == pt_4:

		if GameData.light == "red in front" \
		or GameData.light == "green in right":

			stop_signal = true


# --------------------------------
# NPC DETECTION
# --------------------------------

func _on_area_2d_body_entered(body: Node2D) -> void:

	if body != self and body.is_in_group("npc"):

		other_npc = body

		different_directional_npc = false

		if last_direction == body.last_direction:

			npc_inside = true

		else:

			different_directional_npc = true


func _on_area_2d_body_exited(body: Node2D) -> void:

	if body != self and body.is_in_group("npc"):

		npc_inside = false

		if body == other_npc:

			other_npc = null
			different_directional_npc = false
			
			avoiding = false
			avoid_time = 0.0



# --------------------------------
# DAY CYCLE
# --------------------------------

func timer_updates() -> void:

	if GameData.daycycle == "morning":
		print("fcking morning")

	elif GameData.daycycle == "afternoon":
		print("fcking afternoon")

	elif GameData.daycycle == "night":
		print("fcking night")

func show_light():
	if GameData.daycycle == "night" :
		light.show()
	else:
		light.hide()

func npc_collision() -> void:
	if GameData.npc_collided and GameData.collided_npc_id == npc_id:
		death_label.death_label_show()
		death_label.global_position = global_position
		queue_free()
		
		
