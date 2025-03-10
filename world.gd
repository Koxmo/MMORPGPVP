extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_inventory_gui_closed() -> void:
	get_tree().paused = false # Mettre à remplacer par pass pour enlever la pause


func _on_inventory_gui_opened() -> void:
	get_tree().paused = true # Mettre à remplacer par pass pour enlever la pause
