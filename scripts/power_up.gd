extends Node2D

signal powerup_acquired

@onready var explosion_area: Area2D = $ExplosionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var explosion_activated: bool

func _ready() -> void:
	explosion_activated = false

func _on_life_timer_timeout() -> void:
	destroy()

func destroy():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	emit_signal("powerup_acquired")
	animation_player.play("explode")
