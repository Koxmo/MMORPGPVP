extends CanvasLayer

@onready var inventory = $InventoryGui
@onready var inventory_button = $InventoryButton # Le TouchScreenButton pour ouvrir l'inventaire

func _ready():
	inventory.close()
	# Connecter le signal `pressed()` du bouton à la fonction `toggle_inventory`
	if not inventory_button.is_connected("pressed", self._on_inventory_button_pressed):
		inventory_button.connect("pressed", self._on_inventory_button_pressed)

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()

func _on_inventory_button_pressed():
	toggle_inventory()

func toggle_inventory():
	if inventory.isOpen:
		inventory.close()
	else:
		inventory.open()
