
extends CharacterBody2D

@export var speed = 100.0

enum RoadDirection { FRONT, RIGHT }
@export var road_direction: RoadDirection = RoadDirection.FRONT

var target: Marker2D
var stop_point: Marker2D
var cross_point: Marker2D
var exit_point: Marker2D
var fuckoff: Marker2D

var fuckedoff = false
var has_passed = false
var car_in_front = false


func _process(_delta: float) -> void:
	GameData.car_pos = global_position

	if fuckedoff:
		queue_free()
		return

	# Check whether the car has reached the crossing point.
	if not has_passed and cross_point != null:
		if global_position.distance_to(cross_point.global_position) < 10.0:
			has_passed = true

	# Once the car has crossed, ignore traffic lights.
	if has_passed:
		target = exit_point
	else:
		# Check the light for this car's direction.
		if road_direction == RoadDirection.RIGHT:
			if GameData.traffic_right_left:
				target = exit_point
			else:
				target = stop_point
		else:
			if GameData.traffic_front_down:
				target = exit_point
			else:
				target = stop_point

	# Remove the car when it reaches the end of the road.
	if fuckoff != null:
		if global_position.distance_to(fuckoff.global_position) < 10.0:
			queue_free()


func _physics_process(_delta: float) -> void:
	if target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if car_in_front:
		velocity = Vector2.ZERO
	else:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self:
		car_in_front = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != self:
		car_in_front = false
