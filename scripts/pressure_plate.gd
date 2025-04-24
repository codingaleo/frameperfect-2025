extends AnimatedSprite2D
class_name PressurePlate

var player
var body_count = 0

@export var pressed : bool = false
@export var toggle : bool = false

func _ready():
	player = get_tree().current_scene.find_child("Player", true, false)
	pressed = false

func _process(delta):
	pass
	

func _on_area_2d_body_entered(body):
	body_count += 1
	if toggle == true:
		if pressed:
			self.play("up")
			pressed = false
		else:
			self.play("down")
			pressed = true
	else:
		pressed = true
		self.play("down")

func _on_area_2d_body_exited(body):
	body_count -= 1
	if (body_count == 0):
		if !toggle:
			pressed = false
			self.play("up")
	
