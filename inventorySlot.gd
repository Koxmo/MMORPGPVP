extends Resource

class_name InventorySlot

@export var item: InventoryItem = null
@export var amount: int = 0

func can_add(amount_to_add: int) -> bool:
	return item and amount + amount_to_add <= item.maxAmountPerStack

func add_items(amount_to_add: int) -> bool:
	if can_add(amount_to_add):
		amount += amount_to_add
		return true
	return false
