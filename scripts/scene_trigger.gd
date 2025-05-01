# HoleTrigger.gd
extends Area2D

@export var target_scene : String = "res://Scenes/scene.tscn"  # Set this in Inspector

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":  # Make sure your player node is named "Player"
		# Only trigger if player is falling into the hole (optional)
		if body.velocity.y > 0:  # Player is moving downward
			transition_to(target_scene)

func transition_to(scene_path):
	# Create a simple fade effect
	var fade = ColorRect.new()
	fade.color = Color.BLACK
	fade.size = get_viewport().size
	get_tree().get_root().add_child(fade)
	
	# Animate fade
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, 0.5)
	await tween.finished
	
	# Change scene
	get_tree().change_scene_to_file(scene_path)
	
	# Fade in
	tween = create_tween()
	tween.tween_property(fade, "color:a", 0.0, 0.5)
	await tween.finished
	fade.queue_free()
