extends Node2D

@export var bubble_speed = 50
@onready var player: CharacterBody2D = $Player
@onready var start_point: Node2D = $StartPoint
@onready var bubbles: Node = $Bubbles
@onready var hud = $CanvasLayer/HUD

@onready var game_timer: Timer = $GameTimer
@onready var spawner: Node2D = $Player/Camera2D/Spawner
@onready var spawn_timer: Timer = $SpawnTimer
@onready var fail_sound = $Sounds/FailSound
@onready var pop_sound = $Sounds/PopSound
@onready var power_up_aquired = $Sounds/PowerUpAquired


var time_elapsed_label
var score = 0
var difficulty_level = 1

var bublle_scene = preload("res://scenes/bubble.tscn")
var powerup = preload("res://scenes/power_up.tscn")
var explosion_scene = preload("res://scenes/explosion_area.tscn")
var game_over_screen = preload("res://scenes/game_over_screen.tscn")

var bubble_instance: Node2D

func _ready() -> void:
	player.connect("took_damage", _on_player_took_damage)
	player.position = start_point.global_position
	hud.set_score_label_value("Bubbles popped: {0}".format([score]))
	hud.set_health_label_value("Health: {0}".format([player.health]))
	get_tree().paused = false

	
func _physics_process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	if player:
		for bubble: Area2D in bubbles.get_children():
			if bubble:
				bubble.look_at(player.position)
				bubble.position += bubble.position.direction_to(player.position) * bubble.get_bubble_speed()/60


func _on_spawn_timer_timeout() -> void:
	spawn_bubble()

func spawn_bubble() -> void:
	if is_instance_valid(spawner):
		bubble_instance = bublle_scene.instantiate()
		bubble_instance.connect("popped", _on_bubble_popped)
		var spawn_point_array: Array = spawner.get_children()
		var spawn_point: Marker2D = spawn_point_array.pick_random()
		bubble_instance.position = spawn_point.global_position
		bubble_instance.set_bubble_speed(bubble_speed)
		bubbles.add_child(bubble_instance, true)
	
func increase_difficulty_level():
	if difficulty_level < 5:
		difficulty_level += 1
		bubble_speed += 10
		print("LEVEL: ", difficulty_level)
	
func _on_bubble_popped() -> void:
	pop_sound.play()
	if is_instance_valid(hud):
		score += 1 * difficulty_level
		hud.set_score_label_value("Bubbles popped: {0}".format([score]))
	
func _on_player_took_damage() -> void:
	if is_instance_valid(hud):
		player.health -= 1
		hud.set_health_label_value("Health: {0}".format([player.health]))
		if player.health <= 0:
			gameover()

func _on_game_timer_timeout() -> void:
	increase_difficulty_level()

func _on_power_up_timer_timeout() -> void:
	if is_instance_valid(spawner):
		var spawn_point_array: Array = spawner.get_children()
		var spawn_point: Marker2D = spawn_point_array.pick_random()
		var spawn_point_position = spawn_point.global_position
		var powerup_instance: Area2D = powerup.instantiate()
		powerup_instance.position = spawn_point_position
		powerup_instance.connect("powerup_acquired", _on_powerup_aquired)
		add_child(powerup_instance, true)
	
func _on_powerup_aquired(instance) -> void:
	power_up_aquired.play()
	instance.queue_free()
	player.activate_invulnerablility()
	
func gameover() -> void:
	var gameover_instance = game_over_screen.instantiate()
	hud.add_child(gameover_instance)
	player.die()
	for bubble: Area2D in bubbles.get_children():
		bubble.queue_free()
	fail_sound.play()
	spawn_timer.paused = true
	player.toggle_movement(false)
	get_tree().paused = true
