extends Control

func _on_retry_button_pressed():
	get_tree().reload_current_scene()


func _on_exit_button_pressed():
	get_tree().quit()
