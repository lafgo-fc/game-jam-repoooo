extends CharacterBody2D

@export var speed = 100.0

var target: Marker2D
var stop_point: Marker2D
var cross_point: Marker2D
var exit_point: Marker2D
var fuckoff : Marker2D
var fuckedoff = false
var has_passed = false
@onready var car_sprite = $Sprite2D

func _process(delta: float) -> void:
	GameData.car_pos = global_position
	if fuckedoff == true:
		queue_free()
	if GameData.car_pos.x>0:
		car_sprite.flip_h = true
	else:
		car_sprite.flip_h = false
	# If the car has already crossed the intersection,
	# it should always continue toward the exit.
	if has_passed:
		target = exit_point

	# If the light is green, the car can move toward the exit.
	else:
		if GameData.traffic_right_left == true:
			target = exit_point
		elif GameData.traffic_front_down == true:
			target = exit_point
		else:
			target = stop_point

	# Check if the car has actually crossed the intersection.
	if cross_point != null:
		if global_position.distance_to(cross_point.global_position) < 10:
			has_passed = true

	if fuckoff != null:
		if global_position.distance_to(fuckoff.global_position) < 10:
			queue_free()



func _physics_process(delta: float) -> void:

	if target == null:
		return

	var direction = global_position.direction_to(target.global_position)

	velocity = direction * speed

	move_and_slide()
