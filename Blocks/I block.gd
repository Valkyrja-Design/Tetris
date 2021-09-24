extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var i_block = get_node(".")
onready var blocks = i_block.get_children()
var time_since_last_moved = 0
onready var transforms = [Transform2D(PI/2,i_block.global_position+15*Vector2(1,-1))]
# Called when the node enters the scene tree for the first time.
func _ready():
	#i_block.set_transform(Transform2D(Vector2(0,1),Vector2(-1,0),Vector2(blocks[1].global_position.x,blocks[1].global_position.y)))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
