extends Control

func _ready():
	var highscore = Global.read_savegame()
	get_node("ColorRect/Highscore").set_text("Highscore : "+String(highscore))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://Game.tscn")


func _on_Button4_pressed():
	get_tree().quit()


func _on_Button2_pressed():
	get_tree().change_scene("res://Controls.tscn")


func _on_Button3_pressed():
	get_tree().change_scene("res://Score_Values.tscn")
