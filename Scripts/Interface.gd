extends CanvasLayer

const HUD_HEART_EMPTY = preload("res://Assets/HUD/hudHeart_empty.png")
const HUD_HEART_FULL = preload("res://Assets/HUD/hudHeart_full.png")

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HBoxContainer/Score.text = str(Global.Score)


func _on_character_player_hit():
	Global.player_life -=1
	if Global.player_life <= 0:
		Global.game_over()
	else:
		$HBoxContainer2/TextureRect.texture = HUD_HEART_FULL if Global.player_life >= 1 else HUD_HEART_EMPTY
		$HBoxContainer2/TextureRect2.texture = HUD_HEART_FULL if Global.player_life >= 2 else HUD_HEART_EMPTY
		$HBoxContainer2/TextureRect3.texture = HUD_HEART_FULL if Global.player_life >= 3 else HUD_HEART_EMPTY
