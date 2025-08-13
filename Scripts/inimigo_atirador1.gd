extends CharacterBase

@export var distanciaMin = 300
@export var intervaloTiro = 3

func _ready() -> void:	
	super._ready()
	AtirarNoJogador()
	
func _process(delta: float) -> void:
	if direcaoPlayer().x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _physics_process(delta: float) -> void:

	if Distancia(player) > distanciaMin:
		Mover(direcaoPlayer(), delta)
		PlayAnimation("Walk")
	else:
		Mover(Vector2.ZERO,delta)
		PlayAnimation("Idle")

func AtirarNoJogador():
	shoot(direcaoPlayer())		
	get_tree().create_timer(intervaloTiro).timeout.connect(AtirarNoJogador)


		
