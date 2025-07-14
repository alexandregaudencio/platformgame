class_name CharacterBase extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var ACCELERATION = 2000
@export var SPEED = 300.0
@export var vida = 5
@export_range(0.5, 2.0, 0.1) var massa:float  = 1
signal VidaMudou(vida)
signal danoAplicado(dano)


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
	if dano > vida:
		vida = 0
	else:
		vida -= dano
	emit_signal("DanoAplicado",dano)
	emit_signal("VidaMudou",vida)
	if(vida == 0):
		Destruir()
	
	
func Destruir():
	queue_free()	

func AddImpulso(impulso: Vector2):
	velocity += impulso /massa
	
func direcaoPlayer():
	if !get_node("../Player") : return direcao(position)
	return direcao((get_node("../Player").position))

func direcao(alvo: Vector2):
		return (alvo - global_position).normalized()

	
