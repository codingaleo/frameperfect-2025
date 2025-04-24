extends AnimatableBody2D

@export var starting_pos: Vector2 = Vector2(100, 200)
@export var ending_pos: Vector2 = Vector2(400, 200)
@export var speed: float = 1.0

var t: float = 0.0
var direction: int = 1

func _ready():
	if starting_pos != Vector2.ZERO and ending_pos != Vector2.ZERO:
		position = starting_pos

func _process(delta: float):
	if starting_pos == Vector2.ZERO and ending_pos == Vector2.ZERO:
		return
	t += direction * delta * speed

	if t >= 1.0:
		t = 1.0
		direction = -1
	elif t <= 0.0:
		t = 0.0
		direction = 1

	var new_x = lerp(starting_pos.x, ending_pos.x, t)
	var new_y = lerp(starting_pos.y, ending_pos.y, t)
	position = Vector2(new_x, new_y)
