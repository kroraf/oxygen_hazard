extends Camera2D
class_name PlayerCamera



func update_limits(bounds: Array[Vector2]) -> void:
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
