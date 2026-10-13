extends CharacterBody2D

@export var speed = 100.0

var target: Marker2D
var stop_point: Marker2D
var cross_point: Marker2D
var exit_point: Marker2D
var fuckoff: Marker2D

var fuckedoff = false
var has_passed = false
var car_in_front = false


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
	if body != self:
		car_in_front = true
	if body.is_in_group("npc"):
		GameData.npc_collided = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != self:
		car_in_front = false
	elif body.is_in_group("npc"):
		GameData.npc_collided = false
