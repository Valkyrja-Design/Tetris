extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var i_block = get_node(".")
onready var blocks = i_block.get_children()
var time_since_last_moved = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (time_since_last_moved >= 1):
		for i in blocks:
			i.position.y += 30
		time_since_last_moved = 0
	if (Input.is_action_just_pressed(("ui_right"))):
		for i in blocks:
			i.position.x += 30
	if (Input.is_action_just_pressed("ui_left")):
		for i in blocks:
			i.position.x -= 30
	
	time_since_last_moved += delta
