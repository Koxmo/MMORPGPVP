extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 100
@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtBox = $hurtBox
@onready var sprite = $Sprite2D
@onready var hurtTimer = $hurtTimer
@onready var weapon = $weapon
@onready var collision = $CollisionShape2D  # ✅ Ajout de la collision
@onready var respawn_menu: Control = $RespawnMenu  # ✅ Ajout du menu de respawn

@export var maxHealth = 100
@export var knockbackPower: int = 500
@export var inventory: Inventory

var isHurt: bool = false
var isAttacking: bool = false
var currentHealth: int = maxHealth
var last_direction = Vector2.ZERO
var is_flipped = false
var is_dead: bool = false  # ✅ Ajout d'un booléen pour la mort

func _ready():
	currentHealth = maxHealth
	effects.play("RESET")
	weapon.visible = false
	weapon.disable()
	respawn_menu.visible = false  # 🛑 Cache le menu de respawn au départ

func handleInput():
	if is_dead:
		return  # 🛑 Empêche les inputs si mort
	
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	if is_dead:
		return  # 🛑 Impossible d'attaquer si mort

	isAttacking = true
	if is_flipped:
		animations.play("AttackLeft")
	else:
		animations.play("AttackRight")
	weapon.visible = true
	weapon.enable()
	await animations.animation_finished
	isAttacking = false
	weapon.visible = false
	weapon.disable()

func updateAnimation():
	if is_dead:
		return  # 🛑 Pas d'animation si mort

	if isAttacking: return

	if velocity.length() == 0:
		animations.play("IdleRight")
		sprite.flip_h = is_flipped
	else:
		if velocity.x < 0:
			animations.play("WalkRight")
			sprite.flip_h = true
			is_flipped = true
		elif velocity.x > 0:
			animations.play("WalkRight")
			sprite.flip_h = false
			is_flipped = false
		elif velocity.y != 0:
			animations.play("WalkRight")
			sprite.flip_h = is_flipped

func _physics_process(_delta):
	if is_dead:
		return  # 🛑 Stoppe tout mouvement si mort
	
	handleInput()
	if velocity.length() > 0:
		last_direction = velocity
	move_and_slide()
	updateAnimation()

	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)

func hurtByEnemy(area):
	if is_dead:
		return  # 🛑 Ne pas prendre de dégâts si mort

	currentHealth -= 10
	if currentHealth <= 0:
		die()
		return

	healthChanged.emit()
	isHurt = true

	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func die():
	if is_dead:
		return  # 🛑 Évite d’appeler la mort plusieurs fois

	is_dead = true
	currentHealth = 0
	healthChanged.emit()
	print("☠️ Le joueur est mort !")

	# 🟢 Jouer l'animation de mort
	animations.play("Death")

	# Désactiver le mouvement et les collisions
	velocity = Vector2.ZERO
	collision.set_deferred("disabled", true)

	# ⏳ Attendre 2 secondes avant d'afficher le menu de respawn
	await get_tree().create_timer(2.0).timeout
	show_respawn_menu()

func show_respawn_menu():
	get_tree().paused = true  # 🛑 Met le jeu en pause
	respawn_menu.visible = true  # ✅ Affiche le menu de respawn

func _on_hurt_box_area_entered(area: Area2D):
	if area.has_method("collect"):
		area.collect(inventory)

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func _on_hurt_box_area_exited(_area: Area2D):
	pass  # Correction du paramètre non utilisé

func _on_attack_pressed():
	attack()
