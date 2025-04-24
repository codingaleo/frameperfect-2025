extends Node2D

var being_pushed = false
var push_direction = 0
var push_speed = 40
var original_position = Vector2.ZERO

@export var speed = 60
@export var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if being_pushed:
		position.x += push_direction * push_speed * delta
	else:
		pass
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		# Determine push direction based on player's position
		if body.global_position.x < global_position.x:
			push_direction = 1  # Push right
		else:
			push_direction = -1  # Push left
		
		being_pushed = true
			
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		being_pushed = false

func _on_timer_timeout():
	get_tree().reload_current_scene()
