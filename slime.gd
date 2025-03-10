extends CharacterBody2D

signal health_changed(new_health)  # Signal pour notifier les changements de santé

@export var speed = 20
@export var movement_range = 20
@export var max_health = 30  # Points de vie maximum
var health = max_health       # Points de vie actuels

@onready var sprite = $Sprite2D
@onready var animations = $AnimationPlayer

var target_position: Vector2
var last_velocity = Vector2.ZERO

var isDead: bool = false

func _ready():
	set_random_target_position()
	health = max_health  # Réinitialiser health à max_health au démarrage
	emit_signal("health_changed", health)  # Émettre le signal initial

func set_random_target_position():
	var random_offset = Vector2(
		randf_range(-movement_range, movement_range),
		randf_range(-movement_range, movement_range)
	)
	target_position = global_position + random_offset

func update_velocity():
	var move_direction = (target_position - global_position)
	if move_direction.length() < 1:
		set_random_target_position()
	velocity = move_direction.normalized() * speed

func update_animation():
	if velocity.length() == 0:
		animations.play("IdleRight")
		sprite.flip_h = (last_velocity.x < 0)
	else:
		animations.play("WalkRight")
		sprite.flip_h = (velocity.x < 0)

func _physics_process(delta):
	if isDead: return

	update_velocity()
	last_velocity = velocity
	move_and_slide()
	update_animation()

func take_damage(damage):
	if isDead: return  # Ne pas prendre de dégâts si déjà mort
	health -= damage
	print("Slime taking damage - New health: ", health)  # Débogage pour confirmer
	emit_signal("health_changed", health)  # Émettre le signal quand health change
	if health <= 0:
		die()

func die():
	$hitBox.set_deferred("monitorable", false)  # Désactiver hitBox avant de mourir
	isDead = true
	animations.play("Death")
	await animations.animation_finished
	queue_free()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area == $hitBox: return
	take_damage(10)  # Exemple de dégâts pris, mais tu peux le modifier
