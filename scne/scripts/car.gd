
extends CharacterBody2D

@export var speed: float = 100.0

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
@onready var death_label_scene = $death_label_ui

var target: Marker2D
var stop_point: Marker2D
var cross_point: Marker2D
var exit_point: Marker2D
var fuckoff: Marker2D
var last_direction: String = ""

var fuckedoff: bool = false
var has_passed: bool = false
var car_in_front: bool = false
var vehicle_opt: AnimatedSprite2D
var vehicle_move: bool = false

var blocking_bodies: Array[Node2D] = []
var waiting_time: float = 0.0
var is_waiting: bool = false
var collision_shape_base_position: Vector2
var collision_range_base_position: Vector2
var car_wait : int = 0
var stop_signal = false


func _ready() -> void:
	add_to_group("car")
	var vehicles = [
		van, taxi, luxury, jeep, civic,
		truck, bus, polic_car, ambulance
	]

	var selected_vehicle = vehicles.pick_random()

	for vehicle in vehicles:
		vehicle.hide()

	selected_vehicle.show()
	vehicle_opt = selected_vehicle

	collision_shape.position = Vector2.ZERO
	collsion_range.position = Vector2.ZERO

	match selected_vehicle.name:
		"van":
			collision_shape.scale = Vector2(1.0, 1.0)
			collsion_range.scale = Vector2(1.0, 1.3)
		"taxi", "luxury":
			collision_shape.scale = Vector2(1.3, 0.9)
			collsion_range.scale = Vector2(1.3, 1.3)
		"jeep":
			collision_shape.scale = Vector2(0.8, 0.9)
			collsion_range.scale = Vector2(1.0, 1.3)
		"civic":
			collision_shape.scale = Vector2(0.8, 0.8)
			collsion_range.scale = Vector2(1.0, 1.3)
		"truck":
			collision_shape.scale = Vector2(1.7, 1.5)
			collsion_range.scale = Vector2(1.9, 1.7)
			collsion_range.position = Vector2(0.0, -10.0)
		"bus":
			collision_shape.scale = Vector2(2.1, 1.5)
			collision_shape.position = Vector2(5.0, -10.0)
			collsion_range.scale = Vector2(2.3, 1.9)
			collsion_range.position = Vector2(2.0, -10.0)
		"polic car":
			collision_shape.scale = Vector2(1.2, 1.0)
			collsion_range.scale = Vector2(1.4, 1.4)
		"ambulance":
			collision_shape.scale = Vector2(1.6, 1.3)
			collision_shape.position = Vector2(0.0, -7.0)
			collsion_range.scale = Vector2(1.7, 1.6)
			collsion_range.position = Vector2(0.0, -7.0)
	collision_shape_base_position = collision_shape.position
	collision_range_base_position = collsion_range.position


func _process(_delta: float) -> void:
	GameData.car_pos = global_position

	if fuckedoff:
		queue_free()
		return

	if not has_passed:

		if GameData.traffic_right_left and (last_direction == "right" or last_direction == "left"):
			target = cross_point
			stop_signal = true

		elif GameData.traffic_front_down and (last_direction == "top" or last_direction == "down"):
			target = cross_point
			stop_signal = true

		else:
			target = stop_point

	if has_passed:
		target = exit_point
		stop_signal = false

	if cross_point != null and not has_passed:
		if global_position.distance_to(cross_point.global_position) < 10.0:
			has_passed = true


	if fuckoff != null:
		if global_position.distance_to(fuckoff.global_position) < 25.0:
			GameData.car_passed += 1
			GameData.total_waiting_time += waiting_time
			GameData.total_cars += 1
			GameData.average_waiting_time = (
				GameData.total_waiting_time / GameData.total_cars
			)
			queue_free()


func update_waiting_time(delta: float, waiting: bool) -> void:
	if waiting:
		waiting_time += delta
		is_waiting = true
	else:
		is_waiting = false


func _physics_process(delta: float) -> void:
	waiting_time_evaluvation(delta)
	for i in range(blocking_bodies.size() - 1, -1, -1):
		if not is_instance_valid(blocking_bodies[i]):
			blocking_bodies.remove_at(i)
	update_collision_direction()

	var waiting_for_car = not blocking_bodies.is_empty()

	var waiting_for_light = (
		not has_passed
		and target == stop_point
		and stop_point != null
		and global_position.distance_to(stop_point.global_position) < 5.0
	)

	update_waiting_time(delta, waiting_for_car or waiting_for_light)

	if waiting_for_car or waiting_for_light or car_in_front:
		velocity = Vector2.ZERO
		vehicle_move = false
		if vehicle_opt != null:
			vehicle_opt.pause()
		move_and_slide()
		return

	if target == null:
		velocity = Vector2.ZERO
		vehicle_move = false
		move_and_slide()
		return

	var direction: Vector2 = global_position.direction_to(target.global_position)
	var distance: float = global_position.distance_to(target.global_position)

	if distance < 5.0:
		velocity = Vector2.ZERO
		vehicle_move = false
	else:
		velocity = direction * speed
		vehicle_move = true

	process_animation(direction)
	update_collision_direction()
	move_and_slide()


func process_animation(direction: Vector2) -> void:
	if vehicle_opt == null:
		return

	if not vehicle_move:
		vehicle_opt.pause()
		return

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			vehicle_opt.play("right")
			last_direction = "right"
		else:
			vehicle_opt.play("left")
			last_direction = "left"

	elif abs(direction.y) >= abs(direction.x):
		if direction.y > 0:
			vehicle_opt.play("down")
			last_direction = "down"
		else:
			vehicle_opt.play("top")
			last_direction = "top"


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and not blocking_bodies.has(body):
		blocking_bodies.append(body)

	if body.is_in_group("npc") :
		if velocity == Vector2.ZERO and stop_signal == true:
			pass
		else:
			body.npc_collided = true

		if "npc_id" in body:
			GameData.collided_npc_id = body.npc_id

		for child in body.get_children():
			if child.has_method("show_death_label"):
				child.show_death_label()
				break


func _on_area_2d_body_exited(body: Node2D) -> void:
	blocking_bodies.erase(body)

	if body.is_in_group("npc"):
		body.npc_collided = false
		GameData.collided_npc_id = -1

		for child in body.get_children():
			if child.has_method("hide_death_label"):
				child.hide_death_label()
				break
func update_collision_direction():
	var offset = 20.0
	var angle = 0.0
	var direction_offset = Vector2.ZERO

	match last_direction:
		"right":
			angle = 0.0
			direction_offset = Vector2(offset, 0)

		"left":
			angle = PI
			direction_offset = Vector2(-offset, 0)

		"down":
			angle = PI / 2
			direction_offset = Vector2(0, offset)

		"top":
			angle = -PI / 2
			direction_offset = Vector2(0, -offset)

	collision_shape.rotation = angle
	collision_shape.position = collision_shape_base_position

	collsion_range.rotation = angle
	collsion_range.position = collision_range_base_position + direction_offset
func waiting_time_evaluvation(delta : float):
	if velocity == Vector2.ZERO:
		car_wait += delta
		GameData.car_waiting_time += delta
		
