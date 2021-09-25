extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var gamenode = get_node(".")
onready var rng = RandomNumberGenerator.new()
var blocks = [preload("res://Blocks/Block scenes/I block.tscn"),preload("res://Blocks/Block scenes/J block.tscn"),preload("res://Blocks/Block scenes/L block.tscn"),
preload("res://Blocks/Block scenes/O block.tscn"),preload("res://Blocks/Block scenes/S block.tscn"),preload("res://Blocks/Block scenes/T block.tscn"),preload("res://Blocks/Block scenes/Z block.tscn")]
var curr_block = null
var time_last_moved = 0
var occu = []


func _ready():
	rng.randomize()
	curr_block = blocks[rng.randi_range(0,6)].instance()
	add_child(curr_block)
	for i in range(200):
		occu.append([0,null])
	for i in curr_block.get_children():
		var x = int((i.global_position.x-30)/30)
		var y = int(i.global_position.y/30)
		#print(x,y)
		occu[x+10*y] = [1,i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (time_last_moved >= 1):
		move_down()
		time_last_moved = 0
	if (Input.is_action_just_pressed("ui_down")):
		move_down()
	rotate_block()
	moveright()
	moveleft()
	time_last_moved += delta
	
func moveright():
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
			if ((x+1+10*y < 200) and occu[x+1+10*y][0] == 1 and !((x+1+10*y) in children_positions)):
				flag = false
				break
			if (i.global_position.x + 30 >= 330):
				flag = false
				break 
		if (flag == true):
			for i in children_positions:
				occu[i] = [0,null]
			curr_block.position.x += 30
			for i in children:
				var x = int((i.global_position.x-30)/30)
				var y = int(i.global_position.y/30)
				#print("right: ", x+10*y)
				occu[x+10*y] = [1,i]

func moveleft():
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
			if ((x-1+10*y > 0) and occu[x-1+10*y][0] == 1 and !((x-1+10*y) in children_positions)):
				flag = false
				break
			if (i.global_position.x - 60 <= 0):
				flag = false
				break 
		if (flag == true):
			for i in children_positions:
				occu[i] = [0,null]
			curr_block.position.x -= 30
			for i in children:
				var x = int((i.global_position.x-30)/30)
				var y = int(i.global_position.y/30)
				#print("right: ", x+10*y)
				occu[x+10*y] = [1,i]

func new_block():
	curr_block = blocks[rng.randi_range(0,6)].instance()
	for i in range(20):
		var score = true
		for j in range(10):
			if (occu[j+10*i][0] == 0):
				score = false
				break
		if (score == true):
			for j in range(10):
				#print(j+10*i)
				occu[j+10*i][1].queue_free()
				occu[j+10*i] = [0,null]
			for j in range(i-1,-1,-1):
				for k in range(10):
					if (occu[k+10*j][0] == 1):
						occu[k+10*(j+1)] = occu[k+10*j]
						#print(occu[k+10*(j)][1])
						occu[k+10*(j)][1].global_position.y += 30
						occu[k+10*j] = [0,null]
	add_child(curr_block)
	for newchild in curr_block.get_children():
		var xnew = int((newchild.global_position.x-30)/30)
		var ynew = int(newchild.global_position.y/30)
	#print(x,y)
		occu[xnew+10*ynew] = [1,newchild]
	
func move_down():
	var flag = true
	var children = curr_block.get_children()
	var children_positions = []
	for i in children:
		var x = int((i.global_position.x-30)/30)
		var y = int(i.global_position.y/30)
		children_positions.append(x+10*y)
	#curr_block.get_
	for child in children:
		var x = int((child.global_position.x-30)/30)
		var y = int(child.global_position.y/30)
		#print("for: ", x+10*y)
		if ((x+10*(y+1) < 200) and occu[x+10*(y+1)][0] == 1 and !(x+10*(y+1) in children_positions)):
			flag = false
			new_block()
			break
		if (child.global_position.y+30 > 585):
			flag = false
			new_block()
			break
	if (flag == true):
		for i in children_positions:
			occu[i] = [0,null]
		curr_block.position.y += 30
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			#print("Down: ",x+10*y)
			occu[x+10*y] = [1,i]
				
func rotate_block():
	if (Input.is_action_just_pressed("ui_up")):
		var flag = true
		var origin = curr_block.global_position
		var child_positions = []
		for block in curr_block.get_children():
			var x = int((block.global_position.x-30)/30)
			var y = int((block.global_position.y)/30)
			child_positions.append(x+10*y)
		var xmin = 15
		var xmax = 285
		var ymax = 585
		for block in curr_block.get_children():
			var relx = block.global_position.x - origin.x
			var rely = block.global_position.y - origin.y
			var temp = relx
			relx = rely 
			rely = -temp
			var x = int((relx + origin.x -30)/30)
			var y = int((rely + origin.y)/30)
			if (occu[x+10*y][0] == 1 and !(x+10*y in child_positions)):
				flag = false
				break
			if (relx + origin.x - 30 < 15 || rely + origin.y > 585 || relx + origin.x - 30 > 285):
				xmin = min(xmin,relx+origin.x-30)
				ymax = max(ymax,rely+origin.y)
				xmax = max(xmax, relx+origin.x - 30)
		if (flag):
			child_positions.clear()
			for block in curr_block.get_children():
				var x = int((block.global_position.x-30)/30)
				var y = int((block.global_position.y)/30)
				child_positions.append(x+10*y)
			var possible = true
			if (xmin < 15):
				possible = right_possible(-xmin + 15)
			if (xmax > 285):
				possible = left_possible(xmax-285)
			if (ymax > 585):
				curr_block.global_position.y -= (ymax - 585)
			if (possible):
				remove_occu()
				curr_block.rotate(PI/2)
				for block in curr_block.get_children():
					block.rotate(-PI/2)
				update_occu()
			
func update_occu():
	for block in curr_block.get_children():
		var x = int((block.global_position.x - 30)/30)
		var y = int(block.global_position.y/30)
		#print("add:", x+10*y)
		occu[x+10*y] = [1,block]

func remove_occu():
	for block in curr_block.get_children():
		var x = int((block.global_position.x - 30)/30)
		var y = int(block.global_position.y/30)
		#print("add:", x+10*y)
		occu[x+10*y] = [0,null]

func right_possible(distance):
	var children_positions = []
	for block in curr_block.get_children():
		var x = int((block.global_position.x-30)/30)
		var y = int((block.global_position.y)/30)
		children_positions.append(x+10*y)
	var children = curr_block.get_children()
	var flag = true
	var k = int(distance/30)
	for i in children:
		var x = int((i.global_position.x-30)/30)
		var y = int(i.global_position.y/30)
		if ((x+k+10*y < 200) and occu[x+k+10*y][0] == 1 and !((x+k+10*y) in children_positions)):
			flag = false
			break
		if (i.global_position.x + distance >= 330):
			flag = false
			break 
	if (flag == true):
		for i in children_positions:
			occu[i] = [0,null]
		curr_block.position.x += distance
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [1,i]
	return flag

func left_possible(distance):
	var flag = true 
	var children = curr_block.get_children()
	var children_positions = []
	for i in children:
		var x = int((i.global_position.x-30)/30)
		var y = int(i.global_position.y/30)
		children_positions.append(x+10*y)
	var k = int(distance/30)
	for i in children:
		var x = int((i.global_position.x-30)/30)
		var y = int(i.global_position.y/30)
		if ((x-k+10*y > 0) and occu[x-k+10*y][0] == 1 and !((x-k+10*y) in children_positions)):
			flag = false
			break
	if (flag == true):
		for i in children_positions:
			occu[i] = [0,null]
		curr_block.position.x -= distance
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [1,i]
	return flag
