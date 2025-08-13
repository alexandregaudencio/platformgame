extends CharacterBase

@export var distanciaMin = 300
@export var intervaloTiro = 3
@export var projetilCount: int = 10
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
	#AtirarTodasAsDirecoes()
	get_tree().create_timer(intervaloTiro).timeout.connect(AtirarNoJogador)



func AtirarTodasAsDirecoes():
	var angle_step := TAU / projetilCount

	for i in projetilCount:
		var angle := i * angle_step
		var direction := Vector2.RIGHT.rotated(angle)
		shoot(direction)
