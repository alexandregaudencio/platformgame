extends RigidBody2D
@export var speed = 700
@export var alvo = ""
var direction: Vector2


#func _ready() -> void:
	#var forward = Vector2.RIGHT.rotated(rotation)
	#SetDirection(forward)
	
func SetDirection( direction:Vector2):
	self.direction = direction
	linear_velocity = direction*speed
	
func SetPosition(position:Vector2):
	self.position = position
	

func Destruir():
	queue_free()


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group(alvo):
		print("é do alvo")
	Destruir()
