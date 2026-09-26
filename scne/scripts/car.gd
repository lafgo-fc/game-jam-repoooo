extends CharacterBody2D

@export var speed = 100.0

var target: Marker2D
var stop_point: Marker2D
var cross_point: Marker2D
var exit_point: Marker2D
var fuckoff: Marker2D

var fuckedoff = false
var has_passed = false
<<<<<<< HEAD
func _process(delta: float) -> void:
	GameData.car_pos = global_position
	if fuckedoff == true:
		queue_free()
=======
var car_in_front = false


func _process(delta: float) -> void:
	# Delete the car if it has been marked for removal
	if fuckedoff:
		queue_free()
		return

>>>>>>> 94243bd (lol)
	# If the car has already crossed the intersection,
	# it should always continue toward the exit.
	if has_passed:
		target = exit_point

	# Otherwise, decide where to go based on the traffic light.
	else:
<<<<<<< HEAD
		if GameData.traffic_right_left == true:
=======
		if GameData.traffic:
>>>>>>> 94243bd (lol)
			target = exit_point
		elif GameData.traffic_front_down == true:
			target = stop_point
		else:
			target = stop_point

	# Check if the car has actually crossed the intersection.
	if cross_point != null:
		if global_position.distance_to(cross_point.global_position) < 10:
			has_passed = true
<<<<<<< HEAD

	if fuckoff != null:
		if global_position.distance_to(fuckoff.global_position) < 10:
			queue_free()
=======
>>>>>>> 94243bd (lol)

	# Delete the car when it reaches the off-screen point.
	if fuckoff != null:
		if global_position.distance_to(fuckoff.global_position) < 10:
			print("passed")
			queue_free()


func _physics_process(delta: float) -> void:
	if target == null:
		return

	# If another car is detected in front,
	# stop this car.
	if car_in_front:
		velocity = Vector2.ZERO

	else:
		# Move toward the current target.
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Only react to other cars.
	if body != self:
		car_in_front = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	# The car ahead has left the detection area.
	if body != self:
		car_in_front = false
