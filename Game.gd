extends StaticBody2D

"root/Game/ClearsLabel"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var gamenode = get_node(".")
onready var rng = RandomNumberGenerator.new()
onready var score_label = null
onready var level_label = null
onready var clears_label = null
var blocks = [preload("res://Blocks/Block scenes/I block.tscn"),preload("res://Blocks/Block scenes/J block.tscn"),preload("res://Blocks/Block scenes/L block.tscn"),
preload("res://Blocks/Block scenes/O block.tscn"),preload("res://Blocks/Block scenes/S block.tscn"),preload("res://Blocks/Block scenes/T block.tscn"),preload("res://Blocks/Block scenes/Z block.tscn")]
var curr_block = null
var curr_index = null
var next_index = null
var next_block = null
var total_line_clears = 0
var level = 1
var time_last_moved = 0
var soft_dropinterval = 0
var right_time_interval = 0
var left_time_interval = 0
var occu = []

func _ready():
	rng.randomize()
	score_label = get_node("ScoreLabel")
	level_label = get_node("LevelLabel")
	clears_label = get_node("ClearsLabel")
	score_label.set_text("0")
	level_label.set_text(String(level))
	clears_label = get_node(String(total_line_clears))
	curr_index = rng.randi_range(0,6)
	curr_block = blocks[curr_index].instance()
	next_index = rng.randi_range(0,6)
	next_block = blocks[next_index].instance()
	next_block.global_position.x += 300
	next_block.global_position.y += 60
	add_child(curr_block)
	add_child(next_block)
	for _i in range(200):
		occu.append([0,null])
	for i in curr_block.get_children():
		var x = int((i.global_position.x-30)/30)
		var y = int(i.global_position.y/30)
		#print(x,y)
		occu[x+10*y] = [1,i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	level = int((Global.score)/3000)+1
	level_label.set_text(String(level))
	if (time_last_moved >= 1-(level-1)*.05):
		move_down()
		time_last_moved = 0
	if (Input.is_action_pressed("ui_down") and soft_dropinterval > .06):
		move_down()
		Global.score += 1*level
		score_label.set_text(String(Global.score))
		soft_dropinterval = 0
	# if (Input.is_action_just_pressed("ui_right")):
	# 	moveright()
	# 	right_time_interval = 0
	if (Input.is_action_pressed("ui_right") and right_time_interval > .1 ):
		moveright()
		right_time_interval = 0
	# if (Input.is_action_just_pressed("ui_left")):
	# 	moveleft()
	# 	left_time_interval = 0
	if (Input.is_action_pressed("ui_left") and left_time_interval > .1 ):
		moveleft()
		left_time_interval = 0
	rotate_block()
	hard_drop()
	pause_game()
	continue_game()
	time_last_moved += delta
	soft_dropinterval += delta
	right_time_interval += delta
	left_time_interval += delta

func moveright():
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
		if (i.global_position.x + 30 > 315):
			flag = false
			break 
	if (flag == true):
		for i in children_positions:
			occu[i] = [0,null]
		curr_block.global_position.x += 30
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [1,i]

func moveleft():
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
		if (i.global_position.x - 30 < 45):
			flag = false
			break 
	if (flag == true):
		for i in children_positions:
			occu[i] = [0,null]
		curr_block.global_position.x -= 30
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [1,i]

func new_block():
	var line_clears = 0
	var t_spin = false
	for i in range(20):
		var score = true
		for j in range(10): 
			if (occu[j+10*i][0] == 0):
				score = false
				break
		if (check_tstate()):
			t_spin = true
		if (score == true):
			line_clears += 1
			if check_tstate():
				t_spin = true
#			if (t_spin):
#				#print("T-SPIN!")
#			else:
#				#print("NO")
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
	curr_index = next_index
	curr_block = blocks[next_index].instance()
	next_index = rng.randi_range(0,6)
	next_block.queue_free()
	next_block = blocks[next_index].instance()
	next_block.global_position.x += 300
	next_block.global_position.y += 60
	var gameover = false
	curr_block.hide()
	add_child(curr_block)
	add_child(next_block)
	for newchild in curr_block.get_children():
		var xnew = int((newchild.global_position.x-30)/30)
		var ynew = int(newchild.global_position.y/30)
	#print(x,y)
		if (occu[xnew+10*ynew][0] == 1):
			# print(xnew)
			# print(ynew)
			gameover = true
			break
	if (!gameover):
		for newchild in curr_block.get_children():
			var xnew = int((newchild.global_position.x-30)/30)
			var ynew = int(newchild.global_position.y/30)
			occu[xnew+10*ynew] = [1,newchild]
		curr_block.show()
		if (t_spin):
			total_line_clears += line_clears
			clears_label = get_node("ClearsLabel")
			clears_label.set_text(String(total_line_clears))
			if (line_clears==0):
				return 400
			return (1200+400*(line_clears-1))*level
		else:
			total_line_clears += line_clears
			clears_label = get_node("ClearsLabel")
			clears_label.set_text(String(total_line_clears))
			if (line_clears==0):
				return 0
			return (100+200*(line_clears-1))*level
	else:
		get_tree().change_scene("res://GameOverScene.tscn")
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
			var point = new_block()
			if (point!= null): 
				Global.score += point
				score_label.set_text(String(Global.score))
			break
		if (child.global_position.y+30 > 600):
			flag = false
			var point = new_block()
			if (point!= null): 
				Global.score += point
				score_label.set_text(String(Global.score))
			break
	if (flag == true):
		for i in children_positions:
			occu[i] = [0,null]
		curr_block.global_position.y += 30
		for i in children:
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			#print("Down: ",x+10*y)
			occu[x+10*y] = [1,i]
	return flag	

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
		var temp_positions = []
		for block in curr_block.get_children():
			var relx = block.global_position.x - origin.x
			var rely = block.global_position.y - origin.y
			var temp = relx
			relx = -rely 
			rely = temp
			# if (rely + origin.y > 585 || relx + origin.x < 45 || relx + origin.x > 315):
			# 	flag = false
			# 	break
			temp_positions.append([block,Vector2(relx + origin.x,rely + origin.y)])
			var x = int((relx + origin.x -30)/30)
			var y = int((rely + origin.y)/30)
			if ( x+10*y < 200 and occu[x+10*y][0] == 1 and !(x+10*y in child_positions)):
				flag = false
				#print(flag)
				break
			if (relx + origin.x -30 < 15):
				xmin = min(xmin, relx + origin.x -30)
			if (relx + origin.x -30 > 285):
				xmax = max(xmax, relx + origin.x -30)
			if (rely + origin.y > 585):
				ymax = max(ymax, rely + origin.y)
#		if (!flag && curr_index == 5):
#			if (can_move_down(temp_positions) and ymax<=585):
#				remove_occu()
#				transformBlock()
#				update_occu()
		if (flag):
			var possible = true
			#print(xmin)
			if (xmin < 15):
				possible = can_move_right(15-xmin,temp_positions)
			if (xmax > 285):
				possible = can_move_left(xmax-285,temp_positions)
			if (ymax > 585):
				possible = can_move_up(ymax-585,temp_positions)
			#print(possible)
			if (possible):
				remove_occu()
				transformBlock()
				update_occu()

func transformBlock():
	var origin = curr_block.global_position
	for block in curr_block.get_children():
		var relx = block.global_position.x - origin.x
		var rely = block.global_position.y - origin.y
		var temp = relx
		relx = -rely 
		rely = temp
		block.global_position.x = relx + origin.x
		block.global_position.y = rely + origin.y
		#origin = block.global_position
		#block.set_transform(Transform2D(Vector2(0,1),Vector2(-1,0),block.global_position))
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

func can_move_left(distance,temp_positions):
	var flag = true 
	# var children = curr_block.get_children()
	remove_occu()
	var children_positions = []
	for i in temp_positions:
		var x = int((i[1].x-30)/30) 
		var y = int(i[1].y/30)
		children_positions.append(x+10*y)
	var k = int(distance/30)
	for i in temp_positions:
		var x = int((i[1].x-30)/30)
		var y = int(i[1].y/30)
		if ((x-k+10*y > 0) and occu[x-k+10*y][0] == 1 and !((x-k+10*y) in children_positions)):
			flag = false
			# print(occu[x-k+10*y][0] == 1)
			break
	if (flag == true):
		for i in temp_positions:
			var x = int((i[0].global_position.x-30)/30)
			var y = int(i[0].global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [0,null]
		curr_block.global_position.x -= distance
		for i in temp_positions:
			var x = int((i[0].global_position.x-30)/30)
			var y = int(i[0].global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [1,i[0]]
	return flag


func can_move_right(distance,temp_positions):
	var flag = true 
	# var children = curr_block.get_children()
	remove_occu()
	var children_positions = []
	for i in temp_positions:
		var x = int((i[1].x-30)/30) 
		var y = int(i[1].y/30)
		children_positions.append(x+10*y)
	var k = int(distance/30)
	for i in temp_positions:
		var x = int((i[1].x-30)/30)
		var y = int(i[1].y/30)
		if ((x+k+10*y > 0) and occu[x+k+10*y][0] == 1 and !((x+k+10*y) in children_positions)):
			flag = false
			break
		
	if (flag == true):
		for i in temp_positions:
			var x = int((i[0].global_position.x-30)/30)
			var y = int(i[0].global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [0,null]
		curr_block.position.x += distance
		for i in temp_positions:
			var x = int((i[0].global_position.x-30)/30)
			var y = int(i[0].global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [1,i[0]]
	return flag

func can_move_up(distance,temp_positions):
	var flag = true 
	# var children = curr_block.get_children()
	remove_occu()
	var children_positions = []
	for i in temp_positions:
		var x = int((i[1].x-30)/30) 
		var y = int(i[1].y/30)
		children_positions.append(x+10*y)
	var k = int(distance/30)
	for i in temp_positions:
		var x = int((i[1].x-30)/30)
		var y = int(i[1].y/30)
		if ((x+10*(y-k) > 0) and occu[x+10*(y-k)][0] == 1 and !((x+10*(y-k)) in children_positions)):
			flag = false
			break
	if (flag == true):
		for i in temp_positions:
			var x = int((i[0].global_position.x-30)/30)
			var y = int(i[0].global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [0,null]
		curr_block.position.y -= distance
		for i in temp_positions:
			var x = int((i[0].global_position.x-30)/30)
			var y = int(i[0].global_position.y/30)
			#print("right: ", x+10*y)
			occu[x+10*y] = [1,i[0]]
	return flag

func hard_drop():
	if (Input.is_action_just_pressed("ui_select")):
		while(move_down()):
			Global.score += 2*level
			score_label.set_text(String(Global.score))
	
func game_over():
	pass

func check_tstate():
	if (curr_index == 5):
		var children_positions = []
		var up = false
		var right = false
		var left = false
		for i in curr_block.get_children():
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			children_positions.append(x+10*y)
		for i in curr_block.get_children():
			var x = int((i.global_position.x-30)/30)
			var y = int(i.global_position.y/30)
			if (x+10*(y-1) < 200 and occu[x+10*(y-1)][0] == 1 and !(x+10*(y-1) in children_positions)):
				up = true
			if (x+1+10*y < 200 and occu[x+1+10*y][0] == 1 and !(x+1+10*y in children_positions)):
				right = true
			if (x-1+10*y < 200 and occu[x-1+10*y][0] == 1 and !(x-1+10*y in children_positions)):
				left = true
		return (up and right and left)
	return false

#func can_move_down(temp_positions):
#	var flag = true 
#	# var children = curr_block.get_children()
#	remove_occu()
#	var children_positions = []
#	for i in temp_positions:
#		var x = int((i[1].x-30)/30) 
#		var y = int(i[1].y/30)
#		children_positions.append(x+10*y)
#	var k = 1
#	for i in temp_positions:
#		var x = int((i[1].x-30)/30)
#		var y = int(i[1].y/30)
#		if ((x+10*(y+k) > 0) and occu[x+10*(y+k)][0] == 1 and !((x+10*(y+k)) in children_positions)):
#			flag = false
#			break
#		if (y+1==20):
#			flag = false
#			break
#	if (flag == true):
#		for i in temp_positions:
#			var x = int((i[0].global_position.x-30)/30)
#			var y = int(i[0].global_position.y/30)
#			#print("right: ", x+10*y)
#			occu[x+10*y] = [0,null]
#		curr_block.position.y += 30
#		for i in temp_positions:
#			var x = int((i[0].global_position.x-30)/30)
#			var y = int(i[0].global_position.y/30)
#			#print("right: ", x+10*y)
#			occu[x+10*y] = [1,i[0]]
#	return flag

func pause_game():
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().paused = true

func continue_game():
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().paused = false
