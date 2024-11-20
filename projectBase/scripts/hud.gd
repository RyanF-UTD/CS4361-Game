extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var egg_count = 0  # Tracks the number of collected eggs

func increment_egg_count():
	egg_count += 1
	$EggCounterLabel.text = "Eggs: " + str(egg_count)


func _on_egg_collected() -> void:
	print("Egg collected! Incrementing counter.")  # Debug message
	increment_egg_count()
