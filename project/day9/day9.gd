extends Control

onready var optionMenu = $VBoxContainer/HBoxContainer/OptionButton

var play_animation = false


onready var head = get_node("VBoxContainer/ReferenceRect/TileMap/Perso")
onready var tail = get_node("VBoxContainer/ReferenceRect/TileMap/Perso2")

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/playAnimation.pressed = play_animation
	$VBoxContainer/ReferenceRect.visible = play_animation
	self.rect_min_size = Vector2(0, 50)
	$VBoxContainer/HBoxContainer/playAnimation.connect("toggled", self, "_show_player")
	
	optionMenu.add_item("test", 0)
	optionMenu.add_item("puzzle", 1)
	optionMenu.add_item("test2", 2)
	
	optionMenu.connect("item_selected", self, "_process_with_input")
	
	_process_with_input(0)
	
	head.position = $VBoxContainer/ReferenceRect/TileMap.map_to_world(Vector2(1,1))+Vector2(16,16)
	tail.position = $VBoxContainer/ReferenceRect/TileMap.map_to_world(Vector2(1,1))+Vector2(16,16)

func _process_with_input(index):	
	var input_file = File.new()	
	input_file.open("res://input/9/"+optionMenu.get_item_text(index)+".txt", File.READ)
	
	var tailVectorList = []
	
	var position = Vector2(0,0)
	var previousPosition = position
	var tailPosition = position
	tailVectorList.append(tailPosition)
	
#	for line in input_file.get_as_text().split("\n"):
#		var direction = line.split(" ")[0]
#		var nbCase = int(line.split(" ")[1])
#		for i in range(0, nbCase):
#			if !_nextTo(tailPosition, position):
#				tailPosition = previousPosition
#				tail.position = $VBoxContainer/ReferenceRect/TileMap.map_to_world(tailPosition-position)+Vector2(16,16)
#				if !tailVectorList.has(tailPosition):
#					tailVectorList.append(tailPosition)
#			previousPosition = position
#			if direction == "R":
#				position = Vector2(position.x+1, position.y)
#			elif direction == "U":
#				position = Vector2(position.x, position.y-1)
#			elif direction == "L":
#				position = Vector2(position.x-1, position.y)
#			elif direction == "D":
#				position = Vector2(position.x, position.y+1)
#
#		if (play_animation) :
#			yield(get_tree().create_timer(0.2),"timeout")
#
#	if !_nextTo(tailPosition, position):
#		tailPosition = previousPosition
#		if !tailVectorList.has(tailPosition):
#			tailVectorList.append(tailPosition)
	
	tail.position = $VBoxContainer/ReferenceRect/TileMap.map_to_world(tailPosition-position)+Vector2(16,16)
	
	##part 2
	var tailVectorListPart2 = []
	
	var positions = [Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0)]
	var previous_positions = [Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0), Vector2(0,0)]
	var tail_position = positions[9]
	tailVectorListPart2.append(tail_position)
	
	for line in input_file.get_as_text().split("\n"):
		var direction = line.split(" ")[0]
		var nbCase = int(line.split(" ")[1])
		for i in range(0, nbCase):
			for j in range(0, 9):
				previous_positions[j] = positions[j]
				positions[j+1] = _move_tail_if_needed(positions[j], positions[j+1], previous_positions[j], j == 8, tailVectorListPart2)
			if direction == "R":
				positions[0] = Vector2(positions[0].x+1, positions[0].y)
			elif direction == "U":
				positions[0] = Vector2(positions[0].x, positions[0].y-1)
			elif direction == "L":
				positions[0] = Vector2(positions[0].x-1, positions[0].y)
			elif direction == "D":
				positions[0] = Vector2(positions[0].x, positions[0].y+1)
		
		if (play_animation) :
			yield(get_tree().create_timer(0.2),"timeout")
		
	for j in range(0, 9):
		positions[j] = _move_tail_if_needed(positions[j], positions[j+1], previous_positions[j], j+1 == 9, tailVectorListPart2)
				
	$VBoxContainer/HBoxContainer/puzzle_1.text = str(tailVectorList.size())
	$VBoxContainer/HBoxContainer/puzzle_2.text = str(tailVectorListPart2.size())
						
func _nextTo(position: Vector2, positionToCompare: Vector2):
	return position.x >= positionToCompare.x-1 && position.x <= positionToCompare.x+1 && \
	position.y >= positionToCompare.y-1 && position.y <= positionToCompare.y+1
	
func _move_tail_if_needed(head_position: Vector2, tail_position: Vector2, previous_head_position: Vector2, save_position: bool, tailVectorList):
	if !_nextTo(tail_position, head_position):
		tail_position = previous_head_position
		tail.position = $VBoxContainer/ReferenceRect/TileMap.map_to_world(tail_position-head_position)+Vector2(16,16)
		if !tailVectorList.has(tail_position) && save_position:
			tailVectorList.append(tail_position)
	previous_head_position = head_position
	return tail_position
	
func _show_player(checked):
	$VBoxContainer/ReferenceRect.visible = checked
	play_animation = checked
	if checked:
		self.rect_min_size = Vector2(0, 250)
	else:
		self.rect_min_size = Vector2(0, 50)
