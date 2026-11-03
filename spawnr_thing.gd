extends Node2D

@export var car_scene: PackedScene
@export_enum("front", "right") var road_direction: String = "front"

@export var stop_point: Marker2D
@export var cross_point: Marker2D
@export var exit_point: Marker2D
@export var fuckoff: Marker2D
@export var spawn_time : float = 3

var can_spawn = true

func _ready() -> void:
	spawn_car()


func spawn_car() -> void:
	var car = car_scene.instantiate()

	add_child(car)

	car.global_position = global_position

	car.stop_point = stop_point
	car.cross_point = cross_point
	car.exit_point = exit_point
	car.fuckoff = fuckoff

	#car.road_direction = road_direction


func _on_timer_timeout() -> void:
	if can_spawn:
		spawn_car()
	else:
		pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		can_spawn = false


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("car"):
		can_spawn = true
