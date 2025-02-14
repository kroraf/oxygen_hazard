extends CharacterBody2D

@export var speed = 200
var acc = 400
var fric = 300
var can_move: bool
var health = 5

var is_invulnerable: bool = false

@onready var particle_effect: GPUParticles2D = $FlameParticleEffect
@onready var animated_sprite_2d = $FishSprite
@onready var animation_player = $AnimationPlayer
@onready var invulnerablility_timer = $InvulnerablilityTimer
@onready var invulnerablility_countdown_label = $InvulnerablilityCountdownLabel
@onready var shield_sprite = $ShieldSprite


signal took_damage

func _ready() -> void:
	can_move = true

func input():
	var input_dir = Vector2.ZERO
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	input_dir.normalized()
	return input_dir
	
func accelerate(direction, delta):
	velocity = velocity.move_toward(speed * direction, acc * delta)
	
func slowdown(delta):
	velocity = velocity.move_toward(Vector2.ZERO, fric * delta)
	
func player_move():
	move_and_slide()
	
func _process(delta):
	if invulnerablility_countdown_label.visible == true:
		invulnerablility_countdown_label.text = str(int(invulnerablility_timer.time_left) + 1)
		
func _physics_process(delta):
	var input_dir: Vector2 = input()
	particle_effect.amount_ratio = 0
	if can_move:
		if input_dir:
			animated_sprite_2d.play("move")
			particle_effect.amount_ratio = 1
			if input_dir.x < 0:
				animated_sprite_2d.flip_h = true
				particle_effect.rotate(180)
			elif input_dir.x > 0:
				animated_sprite_2d.flip_h = false
				particle_effect.rotate(0)
		if input_dir != Vector2.ZERO:
			accelerate(input_dir, delta)
		else:
			slowdown(delta)
			animated_sprite_2d.play("idle")
		player_move()
	
func take_damage():
	if not is_invulnerable:
		animation_player.play("hurt")
		emit_signal("took_damage")

func die():
	animated_sprite_2d.play("idle")
	animation_player.play("floating")
	animated_sprite_2d.flip_v = true
	
	
func toggle_movement(value) -> void:
	can_move = value
	
func play_hurt_animation() -> void:
	animation_player.play("hurt")
	
func activate_invulnerablility():
	invulnerablility_timer.start()
	animation_player.stop()
	is_invulnerable = true
	var default_modulation = animated_sprite_2d.modulate
	animated_sprite_2d.modulate.a = 0.4
	shield_sprite.show()
	invulnerablility_countdown_label.show()
	await invulnerablility_timer.timeout
	animated_sprite_2d.modulate = default_modulation
	invulnerablility_countdown_label.hide()
	shield_sprite.hide()
	deactivate_invulnerablility()
	
func deactivate_invulnerablility():
	is_invulnerable = false
