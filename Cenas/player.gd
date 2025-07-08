extends CharacterBody2D

const ACCELERATION = 1000
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	var x :=  Input.get_axis("ui_left", "ui_right")
	var y :=  Input.get_axis("ui_up", "ui_down")
	velocity.x = move_toward(velocity.x, x*SPEED, ACCELERATION*delta)
	velocity.y = move_toward(velocity.y, y*SPEED, ACCELERATION*delta)
	move_and_slide()
