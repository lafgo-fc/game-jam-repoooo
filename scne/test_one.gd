extends Node2D
@onready var day_timer = $daytime     # import the day-night timer

func time_op():
	var time_spent = 1440  - day_timer.time_left  # this gives us the time we have spent in the day
	if time_spent <= 360:
		print("morning")
	elif time_spent <= 600 :
		print("afternoon")
	elif time_spent <= 780 :
		print("evening")
	else:
		print("night")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_op()
