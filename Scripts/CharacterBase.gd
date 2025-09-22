class_name CharacterBase extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var ACCELERATION = 2000
@export var SPEED = 300.0
@export var vida = 5
@export_range(0.5, 2.0, 0.1) var massa:float  = 1
signal VidaMudou(vida)
signal DanoAplicado(dano)

var player: Node2D
func _ready() -> void:
	player = get_node("/root/game 1/Player")
	VfxManager.play(2,global_position)


func PlayAnimation(animation):
	if $AnimatedSprite2D.animation == animation: return
	$AnimatedSprite2D.play(animation)

func Mover(dir: Vector2, delta: float):
	velocity = velocity.move_toward(dir*SPEED, ACCELERATION*delta)
	move_and_slide()

func shoot(dir: Vector2 ):
	var projectile = projectile_scene.instantiate()

	get_tree().get_root().add_child(projectile)
	
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
	VfxManager.play(0,global_position)
	queue_free()	

func AddImpulso(impulso: Vector2):
	velocity += impulso /massa
	
func direcaoPlayer():
	var player = get_node("/root/game 1/Player")
	if !player: return direcao(position)
	return direcao(player.position)


func direcao(alvo: Vector2):
		return (alvo - global_position).normalized()

	
func Distancia(node: Node2D):
	if node == null: return 0
	return self.global_position.distance_to(node.global_position)
	
