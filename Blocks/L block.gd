extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var l_block = get_node(".")
onready var blocks = l_block.get_children()
var time_since_last_moved = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
