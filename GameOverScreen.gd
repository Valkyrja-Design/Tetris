extends Control

var score = Global.score

func _ready():
	var highscore = Global.read_savegame()
	if (Global.score > highscore):
		Global.save(Global.score)
	get_node("Score").set_text("Final Score : "+String(Global.score))

func _on_Retry_pressed():
	Global.score = 0
	get_tree().change_scene("res://Game.tscn")


func _on_Return_pressed():
	Global.score = 0
	get_tree().change_scene("res://Main_Menu.tscn")
