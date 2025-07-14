extends CharacterBase

var moveDir = Vector2(0,0)
var mouseDir = Vector2(0,0)

#Shader blink
#https://youtube.com/shorts/TbRsdlfaTWs?lc=UgyUP5crKatZHd1aYld4AaABAg&si=Yd0UiXycq4bavOQB

func _process(delta: float) -> void:
	var x :=  Input.get_axis("ui_left", "ui_right")
	var y :=  Input.get_axis("ui_up", "ui_down")
	moveDir = Vector2(x,y).normalized()
	updateSpriteFlip()

	
func _physics_process(delta: float) -> void:
	Mover(moveDir, delta)
	
	if Input.is_action_just_pressed("Atirar"):
		var mouse_pos = get_global_mouse_position()
		mouseDir = (mouse_pos - global_position).normalized()
		shoot(mouseDir)
 

func updateSpriteFlip():
	if Input.is_action_pressed("Atirar"):
		$AnimatedSprite2D.flip_h = mouseDir.x > 0
	else:
		$AnimatedSprite2D.flip_h = moveDir.x > 0


	
