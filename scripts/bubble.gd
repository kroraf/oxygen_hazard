extends Area2D

@onready var animation_player = $AnimationPlayer

signal popped
signal popped_animation_finished

var speed: int
var is_in_danger: bool

func _ready() -> void:
	is_in_danger = false
	popped_animation_finished.connect(_on_popped_animation_finished)

func destroy():
	queue_free()
	
func set_bubble_speed(new_value) -> void:
	speed = new_value
	
func get_bubble_speed() -> int:
	return speed


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("popped")
		animation_player.play("pop")
		body.take_damage()
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bubble"):
		emit_signal("popped")
		animation_player.play("pop")
	if area.is_in_group("explosion"):
		is_in_danger = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("explosion"):
		is_in_danger = false
		
func _on_popped_animation_finished():
	destroy()
