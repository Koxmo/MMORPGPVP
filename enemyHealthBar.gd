extends TextureProgressBar

var enemy: Node  # 🔗 Référence à l’ennemi (slime)

func _ready():
	# 🔍 Trouver l’ennemi en remontant la hiérarchie
	var current_node = get_parent()
	while current_node && !("health" in current_node || current_node.has_method("get_health")):
		current_node = current_node.get_parent()
	
	# 🎯 Si un ennemi est trouvé, on initialise la barre de vie
	if current_node:
		enemy = current_node
		_update_health()  # ⚡ Mettre à jour immédiatement la barre

		# 🔄 Connexion au signal pour mise à jour automatique
		if enemy.has_signal("health_changed"):
			enemy.connect("health_changed", _on_health_changed)

		set_process(false)  # ✅ Désactiver _process() (économie de ressources)

# ⚡ Mise à jour automatique via signal
func _on_health_changed(new_health):
	_update_health()

# 📊 Met à jour la barre de vie
func _update_health():
	if enemy:
		if "health" in enemy and "max_health" in enemy:
			max_value = float(enemy.max_health)  # 🔧 Ajuster si max_health doit être limité
			value = float(enemy.health)  # 🔧 Modifier si besoin d’un effet visuel différent
		elif enemy.has_method("get_health") and enemy.has_method("get_max_health"):
			max_value = float(enemy.get_max_health())
			value = float(enemy.get_health())
