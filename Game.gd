extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var rng = RandomNumberGenerator.new()
var blocks = [preload("res://Blocks/I block.tscn"),preload("res://Blocks/J block.tscn"),preload("res://Blocks/L block.tscn"),
preload("res://Blocks/O block.tscn"),preload("res://Blocks/S block.tscn"),preload("res://Blocks/T block.tscn"),preload("res://Blocks/Z block.tscn")]
var curr_block = null
var time_last_moved = 0
var occu = []


func _ready():
	rng.randomize()
	curr_block = blocks[rng.randi_range(0,6)].instance()
	add_child(curr_block)
	for i in range(200):
		occu.append(0)
	for i in curr_block.get_children():
		var x = int((i.global_position.x-30)/30)
		var y = int(i.global_position.y/30)
		#print(x,y)
		occu[x+10*y] = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (time_last_moved >= 1):
		var flag = true
		var children = curr_block.get_children()
		children.invert()
		var children_positions = []
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			children_positions.append(x+10*y)
		#curr_block.get_
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			#print("for: ", x+10*y)
			if ((x+10*(y+1) < 200) and occu[x+10*(y+1)] == 1 and !(x+10*(y+1) in children_positions)):
				flag = false
				curr_block = blocks[rng.randi_range(0,6)].instance()
				add_child(curr_block)
				break
		if (flag == true):
			if (curr_block.position.y+30 <= 585):
				for i in children_positions:
					occu[i] = 0
				curr_block.position.y += 30
				for i in children:
					var x = int((i.global_position.x-30)/30)
					var y = int(i.global_position.y/30)
					#print("Down: ",x+10*y)
					occu[x+10*y] = 1
					
			else:
				curr_block = blocks[rng.randi_range(0,6)].instance()
				add_child(curr_block)
		time_last_moved = 0
	"""if (Input.is_action_just_pressed("ui_right")):
		var flag = true 
		var children = curr_block.get_children()
		var children_positions = []
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			children_positions.append(x+10*y)
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			if ((x+1+10*y < 200) and occu[x+1+10*y] == 1 and !((x+1+10*y) in children_positions)):
				flag = false
				break
			if (i.global_position.x + 30 >= 330):
				flag = false
				break 
		if (flag == true):
			for i in children_positions:
				occu[i] = 0
			curr_block.position.x += 30
			for i in children:
				var x = int((i.global_position.x-30)/30)
				var y = int(i.global_position.y/30)
				#print("right: ", x+10*y)
				occu[x+10*y] = 1"""
	moveright(curr_block, occu)
	moveleft(curr_block,occu)
	time_last_moved += delta
	
func moveright(curr_block, occu):
	if (Input.is_action_just_pressed("ui_right")):
		var flag = true 
		var children = curr_block.get_children()
		var children_positions = []
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			children_positions.append(x+10*y)
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			if ((x+1+10*y < 200) and occu[x+1+10*y] == 1 and !((x+1+10*y) in children_positions)):
				flag = false
				break
			if (i.global_position.x + 30 >= 330):
				flag = false
				break 
		if (flag == true):
			for i in children_positions:
				occu[i] = 0
			curr_block.position.x += 30
			for i in children:
				var x = int((i.global_position.x-30)/30)
				var y = int(i.global_position.y/30)
				#print("right: ", x+10*y)
				occu[x+10*y] = 1

func moveleft(curr_block, occu):
	if (Input.is_action_just_pressed("ui_left")):
		var flag = true 
		var children = curr_block.get_children()
		var children_positions = []
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			children_positions.append(x+10*y)
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			if ((x-1+10*y > 0) and occu[x-1+10*y] == 1 and !((x-1+10*y) in children_positions)):
				flag = false
				break
			if (i.global_position.x - 60 <= 0):
				flag = false
				break 
		if (flag == true):
			for i in children_positions:
				occu[i] = 0
			curr_block.position.x -= 30
			for i in children:
				var x = int((i.global_position.x-30)/30)
				var y = int(i.global_position.y/30)
				#print("right: ", x+10*y)
				occu[x+10*y] = 1
