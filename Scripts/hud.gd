extends Control

@export var Player: CharacterBase



func _on_player_vida_mudou(vida: Variant) -> void:
	$Coracoes.value = vida*2
