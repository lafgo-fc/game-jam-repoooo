
extends CharacterBody2D

@export var speed: float = 100.0

enum RoadDirection { FRONT, RIGHT }
@export var road_direction: RoadDirection = RoadDirection.FRONT

var target: Marker2D
var stop_point: Marker2D
var cross_point: Marker2D
var exit_point: Marker2D
var fuckoff: Marker2D

var fuckedoff: bool = false
var has_passed: bool = false

var blocking_bodies: Array[Node2D] = []

var waiting_time: float = 0.0
var is_waiting: bool = false


func _process(_delta: float) -> void:
	GameData.car_pos = global_position

	if fuckedoff:
		queue_free()
		return

	if not has_passed and cross_point != null:
		if global_position.distance_to(cross_point.global_position) < 10.0:
			has_passed = true

	if has_passed:
		target = exit_point
		return

	var green: bool

	if road_direction == RoadDirection.RIGHT:
		green = GameData.traffic_right_left
	else:
		green = GameData.traffic_front_down

	if green:
		target = cross_point
	else:
		target = stop_point


func update_waiting_time(delta: float, waiting: bool) -> void:
	if waiting:
		waiting_time += delta
		is_waiting = true
	else:
		is_waiting = false


func _physics_process(_delta: float) -> void:
	for i in range(blocking_bodies.size() - 1, -1, -1):
		if not is_instance_valid(blocking_bodies[i]):
			blocking_bodies.remove_at(i)

	var waiting_for_car = not blocking_bodies.is_empty()

	var waiting_for_light = (
		not has_passed
		and target == stop_point
		and stop_point != null
		and global_position.distance_to(stop_point.global_position) < 5.0
	)

	update_waiting_time(
		_delta,
		waiting_for_car or waiting_for_light
	)

	if waiting_for_car:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if waiting_for_light:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var distance = global_position.distance_to(target.global_position)

	if distance < 5.0:
		velocity = Vector2.ZERO
	else:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed

	move_and_slide()

	if fuckoff != null:
		if global_position.distance_to(fuckoff.global_position) < 25.0:
			GameData.car_passed += 1

			GameData.total_waiting_time += waiting_time
			GameData.total_cars += 1

			queue_free()
			return


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and not blocking_bodies.has(body):
		blocking_bodies.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	blocking_bodies.erase(body)
