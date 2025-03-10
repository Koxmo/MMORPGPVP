extends Control

@onready var respawn_button: Button = $RespawnButton
@onready var quit_button: Button = $QuitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer2  # ✅ Ajout de l'AnimationPlayer

func _ready():
	# 🛑 Vérification des boutons
	if respawn_button == null:
		print("❌ ERREUR : RespawnButton est NULL ! Vérifie le nom du nœud.")
	if quit_button == null:
		print("❌ ERREUR : QuitButton est NULL ! Vérifie le nom du nœud.")
	if animation_player == null:
		print("❌ ERREUR : AnimationPlayer est NULL ! Vérifie le nom du nœud.")

	# ✅ Connexion des boutons
	if respawn_button:
		respawn_button.pressed.connect(respawn)
	if quit_button:
		quit_button.pressed.connect(quit_game)

	visible = false  # 🛑 Caché par défaut

func show_respawn_menu():
	visible = true  # ✅ On affiche le menu sans pause
	if animation_player:
		animation_player.play("FadeIn")  # 🔹 Lance l'animation de fade-in

func respawn():
	print("🔄 Respawn au village...")
	get_tree().reload_current_scene()  # ✅ Réapparaître (on enlève la pause ici aussi)

func quit_game():
	print("❌ Fermeture du jeu")
	get_tree().quit()  # 🛑 Quitte le jeu
