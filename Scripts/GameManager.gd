extends Node2D

@export var scoreLabel: Label
@export var nivelLabel: Label
var nivel:int = 1
var scorePoints = 0


func _ready() -> void:
	nivel = 1
	scorePoints = 0


func _on_player_dano_aplicado(dano: Variant) -> void:
	scorePoints += dano*(10*nivel)
	scoreLabel.text =  str(scorePoints)
	AtualizarNivel()
	
func AtualizarNivel(): 
	var proximoNivel = nivel+1
	var pontuacalProximoNivel: int = 50* proximoNivel*proximoNivel
	if(scorePoints >= pontuacalProximoNivel):
		nivel+=1
		nivelLabel.text = "Level "+str(nivel)
		
	
