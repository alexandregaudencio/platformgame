extends RigidBody2D



@export var speed = 700
@export var alvo: Grupos
var direction: Vector2

enum Grupos {
	Inimigos,
	Player
}


func _ready() -> void:
	var forward = Vector2.RIGHT.rotated(rotation)
	SetDirection(forward)
	
	
	
	
func SetDirection( direction:Vector2):
	self.direction = direction
	linear_velocity = direction*speed
	
func SetPosition(position:Vector2):
	self.position = position
	
	


func _on_body_entered(body: Node) -> void:
	print("area entered")
	print(body.is_in_group(str(alvo)))
