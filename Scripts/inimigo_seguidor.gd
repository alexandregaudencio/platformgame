extends CharacterBase

@export var alvo: Node

var dir: Vector2

func _process(delta: float) -> void:
	dir = (Vector2)(alvo.position - global_position).normalized()
	if dir.x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _physics_process(delta: float) -> void:
	Mover(dir, delta)
