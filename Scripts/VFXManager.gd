extends Node

var vfx_scenes: Dictionary = {
	0: preload("res://SmokeVFX.tscn")
}

var pools: Dictionary = {}
const INITIAL_POOL_SIZE := 20
const EFFECT_DURATION := 1.0 # tempo fixo em segundos


func _ready() -> void:
	for key in vfx_scenes.keys():
		_create_pool(key, INITIAL_POOL_SIZE)


func _create_pool(effect_name: int, amount: int) -> void:
	if not pools.has(effect_name):
		pools[effect_name] = []
	for i in amount:
		var instance = vfx_scenes[effect_name].instantiate()
		instance.visible = false
		instance.process_mode = Node.PROCESS_MODE_DISABLED
		add_child(instance)
		pools[effect_name].append(instance)


func play(effect_name: int, position: Vector2, parent: Node = null) -> void:
	if not vfx_scenes.has(effect_name):
		push_error("Efeito '%s' não está registrado." % str(effect_name))
		return

	var effect = _get_free_instance(effect_name)
	if effect == null:
		_create_pool(effect_name, 1)
		effect = _get_free_instance(effect_name)

	# Ativa efeito
	effect.global_position = position
	effect.visible = true
	effect.process_mode = Node.PROCESS_MODE_INHERIT

	if parent:
		parent.add_child(effect)
	else:
		get_tree().current_scene.add_child(effect)

	# Espera 1s e recicla
	var timer := get_tree().create_timer(EFFECT_DURATION)
	timer.timeout.connect(func():
		_recycle(effect_name, effect))


func _get_free_instance(effect_name: int) -> Node:
	for instance in pools[effect_name]:
		if not instance.visible:
			return instance
	return null


func _recycle(effect_name: int, instance: Node) -> void:
	instance.visible = false
	instance.process_mode = Node.PROCESS_MODE_DISABLED
	instance.get_parent().remove_child(instance)
	add_child(instance)
