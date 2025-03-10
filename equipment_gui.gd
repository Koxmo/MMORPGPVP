extends Control

@onready var weapon_slot: TextureRect = $WeaponSlot/Icon
@onready var armor_slot: TextureRect = $ArmorSlot/Icon
@onready var potion_slot: TextureRect = $PotionSlot/Icon

func equip_item(item):
	match item.type:
		"weapon":
			$WeaponSlot.texture = item.texture
			weapon_slot.visible = false  # Cache l'icône de base
		"armor":
			$ArmorSlot.texture = item.texture
			armor_slot.visible = false
		"potion":
			$PotionSlot.texture = item.texture
			potion_slot.visible = false

func unequip_item(slot):
	match slot:
		"weapon":
			$WeaponSlot.texture = null
			weapon_slot.visible = true  # Réaffiche l'icône de base
		"armor":
			$ArmorSlot.texture = null
			armor_slot.visible = true
		"potion":
			$PotionSlot.texture = null
			potion_slot.visible = true
