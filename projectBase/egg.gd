extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

signal collected

func _on_body_entered(body):
	if body.is_in_group("Player"):  # Assuming your player is in the "Player" group
		emit_signal("collected")
		queue_free()  # Remove the coin from the scene
