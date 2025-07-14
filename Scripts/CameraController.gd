extends Node2D

@export var alvo: Node2D
@export var velocidade = 20
@export var positionExtra = Vector2(0,100)

func _process(delta: float) -> void:
	seguir(delta)

func seguir(delta):
	#position = lerp(position,alvo.position + positionExtra,velocidade*delta)
	if !alvo: return;
	position = alvo.position
