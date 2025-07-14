extends CharacterBase

func _process(delta: float) -> void:
	if direcaoPlayer().x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _physics_process(delta: float) -> void:
	Mover(direcaoPlayer(), delta)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		print("player tomou dano")
		body.levarDano(1)
		var impulso = -body.direcao(position)*700
		body.AddImpulso(impulso)
