extends Control

@onready var score = $MarginContainer/HBoxContainer/Score
@onready var health = $MarginContainer/HBoxContainer/Health

func set_score_label_value(new_score):
	score.text = str(new_score)

func set_health_label_value(new_value):
	health.text = str(new_value)
