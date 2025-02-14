extends Node2D

signal powerup_acquired(instance)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_life_timer_timeout() -> void:
	destroy()

func destroy():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	powerup_acquired.emit(self)
