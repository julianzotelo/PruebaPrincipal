extends Node

var Score : int = 0
var player_life : int = 3


func game_over():
		get_tree().change_scene_to_file("res://Escenas/finish.tscn")

func game_victory():
	var scene_finish_instance = preload("res://Escenas/finish.tscn").instantiate()
	scene_finish_instance.set_title("GANASTE")
	add_child(scene_finish_instance)
