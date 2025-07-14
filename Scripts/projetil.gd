extends RigidBody2D
@export var speed = 700
@export var alvo = ""
var direction: Vector2

	
func SetDirection( direction:Vector2):
	self.direction = direction
	linear_velocity = direction*speed
	
func SetPosition(position:Vector2):
	self.position = position
	

func Destruir():
	queue_free()

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group(alvo):
		if(body is CharacterBase):
			body.levarDano(1)
			var impulso = -body.direcaoPlayer()*300
			body.AddImpulso(impulso)
	Destruir()
