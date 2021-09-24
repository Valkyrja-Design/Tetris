extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var s_block = get_node(".")
onready var blocks = s_block.get_children()
var time_since_last_moved = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (Input.is_action_just_pressed(("ui_right"))):
		s_block.rotate(PI/2)
	if (Input.is_action_just_pressed("ui_left")):
		s_block.global_position.x -=30
	
	time_since_last_moved += delta
