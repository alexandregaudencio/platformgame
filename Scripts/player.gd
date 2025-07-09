extends CharacterBody2D

const ACCELERATION = 1000
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var projectile_scene: PackedScene
#para testar vetores
#https://phet.colorado.edu/sims/html/vector-addition/latest/vector-addition_all.html

func _physics_process(delta: float) -> void:
	var x :=  Input.get_axis("ui_left", "ui_right")
	var y :=  Input.get_axis("ui_up", "ui_down")
	velocity.x = move_toward(velocity.x, x*SPEED, ACCELERATION*delta)
	velocity.y = move_toward(velocity.y, y*SPEED, ACCELERATION*delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("mouse"):
		shoot()
 

func shoot():
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	
	projectile.global_position = global_position

	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()

	#projectile.direction = dir

	# Rotaciona o sprite do projétil para apontar na direção correta (opcional)
	projectile.rotation = dir.angle()
