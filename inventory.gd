extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem, amount: int = 1):
	var remaining_amount = amount
	for slot in slots:
		if slot.item and slot.item.name == item.name:
			var amount_to_add = min(remaining_amount, item.maxAmountPerStack - slot.amount)
			if amount_to_add > 0:
				slot.add_items(amount_to_add)
				remaining_amount -= amount_to_add
				if remaining_amount == 0:
					updated.emit()
					return

	# Si aucun slot existant ne peut contenir l'objet, ajoute un nouveau slot
	while remaining_amount > 0:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			var new_slot = emptySlots[0]
			new_slot.item = item
			var amount_to_add = min(remaining_amount, item.maxAmountPerStack)
			new_slot.amount = amount_to_add
			remaining_amount -= amount_to_add
		else:
			break
	updated.emit()
