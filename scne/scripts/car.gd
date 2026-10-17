extends CharacterBody2D

@export var speed = 100.0
@onready var death_label = $"../../death_label"
@onready var van = $van
@onready var taxi = $taxi
@onready var luxury = $luxury
@onready var jeep = $jeep
@onready var civic = $civic
@onready var truck = $truck
@onready var bus = $bus
@onready var polic_car = $"polic car"
@onready var ambulance = $ambulance
@onready var collision_shape = $CollisionShape2D
@onready var collsion_range = $Area2D/collision_range


var target: Marker2D
var stop_point: Marker2D
var cross_point: Marker2D
var exit_point: Marker2D
var fuckoff: Marker2D

var fuckedoff = false
var has_passed = false
var car_in_front = false


func _ready() -> void:
	var vehicle = [van , taxi , luxury , jeep , civic , truck , bus , polic_car , ambulance]
	var selected_vehicle = vehicle.pick_random()
	for vehicles in vehicle:
		vehicles.hide()
	selected_vehicle.show()
	match selected_vehicle.name:
		"van":
			collision_shape.scale = Vector2(1.0 , 1.0)
			collsion_range.scale = Vector2(1.0 , 1.3)
		"taxi":
			collision_shape.scale = Vector2(1.3 , 0.9)
			collsion_range.scale = Vector2(1.3 , 1.3)
		"luxury":
			collision_shape.scale = Vector2(1.3 , 0.9)
			collsion_range.scale = Vector2(1.3 , 1.3)
		"jeep":
			collision_shape.scale = Vector2(0.8 , 0.9)
			collsion_range.scale = Vector2(1.0 , 1.3)
		"civic":
			collision_shape.scale = Vector2(0.8 , 0.8)
			collsion_range.scale = Vector2(1.0 , 1.3)
		"truck":
			collision_shape.scale = Vector2(1.7 , 1.5)
			collsion_range.scale = Vector2(1.9 , 1.7)
			collsion_range.position = Vector2(0.0 , -10.0)
		"bus":
			collision_shape.scale = Vector2(2.1 , 1.5)
			collision_shape.position = Vector2(5.0 , -10.0)
			collsion_range.scale = Vector2(2.3 , 1.9)
			collsion_range.position = Vector2(2.0 , -10.0)
		"polic_car":
			collision_shape.scale = Vector2(1.2 , 1.0)
			collsion_range.scale = Vector2(1.4 , 1.4)
		"ambulance":
			collision_shape.scale = Vector2(1.6 , 1.3)
			collision_shape.position = Vector2(0.0 , -7.0)
			collsion_range.scale = Vector2(1.7 , 1.6)
			collsion_range.position = Vector2(0.0 , -7.0)

func _process(delta: float) -> void:
	GameData.car_pos = global_position

	if fuckedoff:
		queue_free()
		return

	# If the car already crossed the intersection,
	# keep moving toward the exit.
	if has_passed:
		target = exit_point

	else:
		# Decide movement according to traffic light
		if GameData.traffic_right_left:
			target = exit_point

		elif GameData.traffic_front_down:
			target = stop_point

		else:
			target = stop_point

	# Check whether car crossed the intersection
	if cross_point != null:
		if global_position.distance_to(cross_point.global_position) < 10:
			has_passed = true

	# Delete car after it leaves the road
	if fuckoff != null:
		if global_position.distance_to(fuckoff.global_position) < 10:
			queue_free()


func _physics_process(delta: float) -> void:
	if target == null:
		return

	if car_in_front:
		velocity = Vector2.ZERO

	else:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("npc") and velocity.length() > 0:
		GameData.npc_collided = true
		GameData.collided_npc_id = body.npc_id

		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != self:
		car_in_front = false
	if body.is_in_group("npc"):
		GameData.npc_collided = false
