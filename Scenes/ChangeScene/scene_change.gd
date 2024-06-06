extends Area2D

# This will probably work better in the main scene for saving global position

@export var playerEntered = false

# Define the function that will be called when the player enters the trigger area
func _on_body_entered(body):
	# Check if the colliding body is the player character
	if body.name == "CharacterAlex":
		# Set the flag to indicate that the player has entered
		playerEntered = true
		

# Called every frame
func _process(delta):
	# Check if the player has entered and perform deferred scene change
	if playerEntered:
		# Call a function to change the scene 
		get_tree().change_scene_to_file("res://Scenes/Battle/battle_scene.tscn")
		playerEntered = false



