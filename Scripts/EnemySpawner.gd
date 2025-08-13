extends Node2D
@export var enemy_scenes: Array[PackedScene] = []
@export var Enemies_inicial: int = 1
@export var time_between_waves: float = 5.0
@export var max_enemies_per_wave: int = 10
@export var spawn_area: Rect2 = Rect2(Vector2.ZERO, Vector2(20, 200))
var wave_number := 1

func _ready():
	start_waves()
func start_waves():
	spawn_wave()
	get_tree().create_timer(time_between_waves).timeout.connect(start_waves)
func spawn_wave():
	for i in wave_number:
		spawn_enemy()	
	if Enemies_inicial < max_enemies_per_wave:
		wave_number += 1

func spawn_enemy():
	var randi = randi() % enemy_scenes.size()
	print(randi)
	var enemy = enemy_scenes[randi].instantiate()
	var pos = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)
	enemy.position = pos
	add_child(enemy)
	
