extends Control

var notPaused = true
func _ready():
	pass

func _process(_delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		if (notPaused):
			var highscore = Global.read_savegame()
			if (Global.score > highscore):
				Global.save(Global.score)
			get_tree().paused = true
			notPaused = false
			visible = true
		else:
			get_tree().paused = false
			notPaused = true
			visible = false

func _on_Resume_pressed():
	get_tree().paused = false
	notPaused = true
	visible = false

func _on_Menu_pressed():
	get_tree().paused = false
	Global.score = 0
	get_tree().change_scene("res://Main_Menu.tscn")
