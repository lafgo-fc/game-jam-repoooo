extends Node2D
@onready var day_timer = $daytime     # import the day-night timer

func time_op():
	var time_spent = 1440  - day_timer.time_left
	print(time_spent)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_op()
