extends Node2D

var hud
var egg_count = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud = $Layers/HUD


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_Egg_collected():
	egg_count += 1
	hud.update_egg_count(egg_count)
