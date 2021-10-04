extends Label

var score = Global.points
onready var label = get_node(".")
func _ready():
	label.set_text(String(score))


func _process(_delta):
	if (Global!=null):
		score = Global.points
		label.set_text(String(score))
