extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Dynamically connect the "collected" signal from all eggs in the "eggs" group
	for egg in get_tree().get_nodes_in_group("eggs"):
		if egg.has_signal("collected"):
			egg.connect("collected", Callable($HUD, "_on_egg_collected"))
		else:
			print("Egg does not have a 'collected' signal!")
