extends Area2D

@onready var timer = $Timer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var player
var player_sprite
var music

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().current_scene.find_child("Player", true, false)
	player_sprite = player.find_child("Player Sprite")
	music = get_tree().current_scene.find_child("Music")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_body_entered(body):
	player.dead = true
	player_sprite.play("hit")
	music.stop()
	audio_stream_player_2d.play()
	timer.start()


func _on_timer_timeout():
	get_tree().reload_current_scene()
