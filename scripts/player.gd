extends CharacterBody2D

@export var speed = 400
var acc = 1600
var fric = 1300
var can_move: bool

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var particle_effect: GPUParticles2D = $FlameParticleEffect

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
		
func _physics_process(delta):
	var input_dir: Vector2 = input()
	particle_effect.amount_ratio = 0
	if can_move:
		if input_dir:
			particle_effect.amount_ratio = 1
			if input_dir.x < 0:
				sprite_2d.flip_h = true
				particle_effect.rotate(180)
			elif input_dir.x > 0:
				sprite_2d.flip_h = false
				particle_effect.rotate(0)
		if input_dir != Vector2.ZERO:
			accelerate(input_dir, delta)
		else:
			slowdown(delta)
		player_move()
	
func take_damage():
	emit_signal("took_damage")

func die():
	sprite_2d.flip_v = true
	
func toggle_movement(value) -> void:
	can_move = value
