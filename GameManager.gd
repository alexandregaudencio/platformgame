extends Node2D

@export var scoreLabel: Label
@export var nivelLabel: Label
var nivel:int = 1
var scorePoints = 0
@export var LevelUpAudio: AudioStream


func _ready() -> void:
	DadosJogador.connect("Pontos", Callable(self, "_on_PontosMudou"))

func _on_PontosMudou(pontos: int) -> void:
	scorePoints += pontos*(10*nivel)
	scoreLabel.text =  str(scorePoints)
	AtualizarNivel()
	
func AtualizarNivel(): 
	var proximoNivel = nivel+1
	var pontuacalProximoNivel: int = 50* proximoNivel*proximoNivel
	if(scorePoints >= pontuacalProximoNivel):
		nivel+=1
		nivelLabel.text = "Level "+str(nivel)
		AudioManager.play_sfx(LevelUpAudio)
		
	
