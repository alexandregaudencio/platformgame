extends Sprite2D


func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	rotation = dir.angle()
	
	var angle = rad_to_deg(dir.angle())
	if(angle > 90):
		flip_v = true
	else:
		flip_v = false
