extends Area2D

@export var damage = 10  # Définir le nombre de dégâts par défaut

@onready var shape = $CollisionShape2D

func enable():
	shape.disabled = false

func disable():
	shape.disabled = true

func _on_body_entered(body: Node):
	print("Body entered:", body)
	if body.is_in_group("enemies"):
		print("Enemy hit")
		body.take_damage(damage)  # Utiliser la variable damage pour infliger les dégâts
