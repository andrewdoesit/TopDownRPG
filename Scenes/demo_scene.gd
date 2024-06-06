extends Node2D

@export var player_position = Vector2()
@export var playerEntered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check if the player has entered and perform deferred scene change
	if playerEntered:
		# Call a function to change the scene 
		get_tree().change_scene_to_file("res://Scenes/Battle/battle_scene.tscn")
		playerEntered = false


func _on_area_2d_body_entered(body):
	# Check if the colliding body is the player character
	if body.name == "CharacterAlex":
		# Set the flag to indicate that the player has entered
		playerEntered = true

