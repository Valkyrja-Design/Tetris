extends Node2D

var score = 0 
var savegame = File.new() #file
var save_path = "user://savegame.save" #place of the file
var save_data = {"highscore": 0} #variable to store data

func _ready():
	score = 0
	if not savegame.file_exists(save_path):
		create_save()

func create_save():
	savegame.open(save_path,File.WRITE)
	savegame.store_var(save_data)
	savegame.close()
	
func save(high_score):
	save_data["highscore"] = high_score
	savegame.open(save_path,File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func read_savegame():
	savegame.open(save_path, File.READ)
	save_data = savegame.get_var()
	savegame.close()
	return save_data["highscore"]
	
