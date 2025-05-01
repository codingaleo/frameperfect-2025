extends Sprite2D

var player
var player_sprite
var player_text

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().current_scene.find_child("Player", true, false)
	player_sprite = player.find_child("Player Sprite")
	player_text = player.find_child("Player Text")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	print("Level Completed!")
	var random = randf()
	if random < .3:
		player_text.text = "I win!"
	elif random < .6:
		player_text.text = "Too easy..."
	elif random < 1:
		player_text.text = "I beat it!"
