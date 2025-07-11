class_name CharacterBase extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var ACCELERATION = 2000
@export var SPEED = 300.0
@export var vidas = 5




func Mover(dir: Vector2, delta: float):
	velocity = velocity.move_toward(dir*SPEED, ACCELERATION*delta)
	move_and_slide()

func shoot(dir: Vector2, ):
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)

	projectile.SetDirection(dir)
	projectile.SetPosition(global_position + dir*40)
	projectile.rotation = dir.angle()

func levarDano(dano: int):
	if dano > vidas:
		vidas = 0
	else:
		vidas -= dano
	
	if(vidas == 0):
		Destruir()
	
	
func Destruir():
	queue_free()	
		
	
