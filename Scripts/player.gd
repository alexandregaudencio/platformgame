extends CharacterBody2D

@export var ACCELERATION = 2000
@export var SPEED = 300.0

@export var projectile_scene: PackedScene
#para testar vetores
#https://phet.colorado.edu/sims/html/vector-addition/latest/vector-addition_all.html

func _physics_process(delta: float) -> void:
	var x :=  Input.get_axis("ui_left", "ui_right")
	var y :=  Input.get_axis("ui_up", "ui_down")
	var dir := Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
	#var dir := Vector2(x,y).normalized()
	
	#velocity.x = move_toward(velocity.x, dir.x*SPEED, ACCELERATION*delta)
	#velocity.y = move_toward(velocity.y, dir.y*SPEED, ACCELERATION*delta)
	velocity = velocity.move_toward(dir*SPEED, ACCELERATION*delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("Atirar"):
		shoot()
 

func shoot():
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	

	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	
	projectile.SetDirection(dir)
	projectile.SetPosition(global_position + dir*40)
	projectile.rotation = dir.angle()
