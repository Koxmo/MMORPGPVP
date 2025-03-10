extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var amountLabel: Label = $CenterContainer/Panel/Label
@onready var touch_button: TouchScreenButton = $TouchScreenButton  # Gestion du tactile

var is_dragging: bool = false
var dragged_item: InventoryItem = null
var dragged_slot: InventorySlot = null
var dragged_amount: int = 0  # 🔹 Garde la quantité de l'objet déplacé

func _ready():
	touch_button.pressed.connect(_on_touch_pressed)
	touch_button.released.connect(_on_touch_released)
	mouse_filter = Control.MOUSE_FILTER_STOP  # Capture les interactions

func update(slot: InventorySlot):
	if !slot.item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
		amountLabel.visible = false
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = slot.item.texture
		amountLabel.visible = slot.amount > 1
		amountLabel.text = str(slot.amount) if slot.amount > 1 else ""
		itemSprite.scale = calculate_uniform_scale(itemSprite.texture.get_size(), slot.item.inventory_size)

	set_meta("slot_data", slot)

func _on_touch_pressed():
	if itemSprite.visible:
		is_dragging = true
		dragged_slot = get_meta("slot_data")  # Slot d'origine
		dragged_item = dragged_slot.item  # Objet à déplacer
		dragged_amount = dragged_slot.amount  # 🔹 Stocke la quantité

func _on_touch_released():
	if is_dragging:
		var touch_position = get_viewport().get_mouse_position()
		drop_item(touch_position)
		is_dragging = false

func drop_item(position):
	for slot_gui in get_parent().get_children():
		if slot_gui.get_global_rect().has_point(position) and slot_gui != self:
			var target_slot = slot_gui.get_meta("slot_data")  # Slot cible

			if target_slot.item == null:
				# 🟢 Si le slot cible est vide, on met tout dedans
				target_slot.item = dragged_item
				target_slot.amount = dragged_amount
				dragged_slot.item = null
				dragged_slot.amount = 0

			elif target_slot.item.name == dragged_item.name:
				# 🔄 Si c'est le même objet, empiler les quantités
				var max_stack = dragged_item.maxAmountPerStack
				var total_amount = target_slot.amount + dragged_amount

				if total_amount > max_stack:
					target_slot.amount = max_stack
					dragged_slot.amount = total_amount - max_stack  # Garde le surplus
				else:
					target_slot.amount = total_amount
					dragged_slot.item = null
					dragged_slot.amount = 0

			else:
				# 🔀 Si c'est un objet différent, échange
				var temp_item = target_slot.item
				var temp_amount = target_slot.amount
				target_slot.item = dragged_item
				target_slot.amount = dragged_amount
				dragged_slot.item = temp_item
				dragged_slot.amount = temp_amount

			# 🔄 Met à jour l'affichage
			slot_gui.update(target_slot)
			update(dragged_slot)
			break

func calculate_uniform_scale(original_size: Vector2, target_size: Vector2) -> Vector2:
	var scale_factor = min(target_size.x / original_size.x, target_size.y / original_size.y)
	return Vector2(scale_factor, scale_factor)
