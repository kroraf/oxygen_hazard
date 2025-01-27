extends CanvasLayer

@onready var score: Label = $Score
@onready var health: Label = $Health

func set_score_label_value(new_score):
	score.text = str(new_score)

func set_health_label_value(new_value):
	health.text = str(new_value)
