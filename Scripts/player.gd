extends CharacterBase

#para testar vetores
#https://phet.colorado.edu/sims/html/vector-addition/latest/vector-addition_all.html

func _physics_process(delta: float) -> void:
	var x :=  Input.get_axis("ui_left", "ui_right")
	var y :=  Input.get_axis("ui_up", "ui_down")
	var dir := Vector2(x,y).normalized()
	Mover(dir, delta)
	

	
	if Input.is_action_just_pressed("Atirar"):
		var mouse_pos = get_global_mouse_position()
		dir = (mouse_pos - global_position).normalized()
		shoot(dir)
 
