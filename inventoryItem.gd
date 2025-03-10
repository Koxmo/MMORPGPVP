extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmountPerStack: int = 10 # Limite d'objets par slot
@export var inventory_size: Vector2 = Vector2(10, 10)
