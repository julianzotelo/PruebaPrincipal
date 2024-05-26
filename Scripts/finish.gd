extends CanvasLayer


func set_title(tittle):
	$VBoxContainer/Label.text=tittle

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Escenas/grass_platform.tscn")
