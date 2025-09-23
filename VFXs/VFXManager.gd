extends Node

var vfx_scenes: Dictionary = {
	0: preload("res://VFXs/SmokeVFX.tscn"),
	1: preload("res://VFXs/ImpactVFX.tscn"),
	2: preload("res://VFXs/sparkVFX.tscn"),
	3: preload("res://VFXs/particlesVFX.tscn")
}

const EFFECT_DURATION := 1.0

func play(effect_name: int, position: Vector2, rotation: float = 0, parent: Node = null) -> void:
	if not vfx_scenes.has(effect_name):
		push_error("Efeito '%s' não está registrado." % str(effect_name))
		return

	var effect = vfx_scenes[effect_name].instantiate()
	effect.position = position
	#effect.rotation = rotation
	if parent:
		parent.add_child(effect)
	else:
		get_tree().current_scene.add_child(effect)

	var timer := get_tree().create_timer(EFFECT_DURATION)
	timer.timeout.connect(func():
		effect.queue_free()
		)
