extends Node

signal Pontos(pontos)

func EmitirPontos(pontos):
	emit_signal("Pontos",pontos)
