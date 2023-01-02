extends Control

onready var optionMenu = $VBoxContainer/HBoxContainer/OptionButton

var play_animation = false

class RealTreeItem: 
	var value:int
	var visible: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/playAnimation.pressed = play_animation
	$VBoxContainer/ReferenceRect.visible = play_animation
	self.rect_min_size = Vector2(0, 50)
	$VBoxContainer/HBoxContainer/playAnimation.connect("toggled", self, "_show_player")
	
	optionMenu.add_item("test", 0)
	optionMenu.add_item("puzzle", 1)
	
	optionMenu.connect("item_selected", self, "_process_with_input")
	
	_process_with_input(0)

func _process_with_input(index):	
	var input_file = File.new()	
	input_file.open("res://input/8/"+optionMenu.get_item_text(index)+".txt", File.READ)
	
	var treeCoordX = -1
	var treeCoordY = 0
	var nbVisibleTree = 0
	var highestScenicScore = -1
	
	for line in input_file.get_as_text().split("\n"):
		treeCoordX = -1
		for character in line:
			var rightTrees = []
			var leftTrees = []
			var topTrees = []
			var bottomTrees = []
			treeCoordX += 1
			if treeCoordX == 0 || treeCoordY == 0 || treeCoordX == line.length()-1 || treeCoordY == 	input_file.get_as_text().split("\n").size()-1:
				nbVisibleTree += 1
			else:
				var stillVisible = true
				var shouldSearch = true
				var value = int(character)
				for i in range(0, treeCoordX):
					if int(line[i]) >= value:
						stillVisible = false
						break
				if stillVisible:
					nbVisibleTree += 1
					continue
				stillVisible = true
				for i in range(treeCoordX+1, line.length()):
					if int(line[i]) >= value:
						stillVisible = false
						break
				if stillVisible:
					nbVisibleTree += 1
					continue
				stillVisible = true
				for i in range(0, treeCoordY):
					if int(input_file.get_as_text().split("\n")[i][treeCoordX]) >= value:
						stillVisible = false
						break
				if stillVisible:
					nbVisibleTree += 1
					continue
				stillVisible = true
				for i in range(treeCoordY+1, input_file.get_as_text().split("\n").size()):
					if int(input_file.get_as_text().split("\n")[i][treeCoordX]) >= value:
						stillVisible = false
						break
				if stillVisible:
					nbVisibleTree += 1
					continue
					
			#Part 2:
		treeCoordY += 1
		
	treeCoordX = -1
	treeCoordY = 0
	for line in input_file.get_as_text().split("\n"):
		treeCoordX = -1
		for character in line:
			var rightTrees = []
			var leftTrees = []
			var topTrees = []
			var bottomTrees = []
			treeCoordX += 1
			var value = int(character)
			for i in range(0, treeCoordX):
				leftTrees.append(int(line[i]))
			for i in range(treeCoordX+1, line.length()):
				rightTrees.append(int(line[i]))
			for i in range(0, treeCoordY):
				topTrees.append(int(input_file.get_as_text().split("\n")[i][treeCoordX]))
			for i in range(treeCoordY+1, input_file.get_as_text().split("\n").size()):
				bottomTrees.append(int(input_file.get_as_text().split("\n")[i][treeCoordX]))
					
			leftTrees.invert()
			topTrees.invert()
			
			var totalScenicScore = _get_direction_scenic_score(value, rightTrees) * \
			_get_direction_scenic_score(value, leftTrees) * \
			_get_direction_scenic_score(value, topTrees) * \
			_get_direction_scenic_score(value, bottomTrees)
			
			if highestScenicScore == -1 || totalScenicScore > highestScenicScore:
				highestScenicScore = totalScenicScore
		treeCoordY += 1
		
	$VBoxContainer/HBoxContainer/puzzle_1.text = str(nbVisibleTree)
	$VBoxContainer/HBoxContainer/puzzle_2.text = str(highestScenicScore)
						
func _get_direction_scenic_score(value, toProcess):
	if (toProcess.size()==0):
		return 0
	var scenicScore = 0
	for i in range(0, toProcess.size()):
		scenicScore += 1
		if (toProcess[i] >= value):
			return scenicScore
	return scenicScore
						
func _show_player(checked):
	$VBoxContainer/ReferenceRect.visible = checked
	play_animation = checked
	if checked:
		self.rect_min_size = Vector2(0, 250)
	else:
		self.rect_min_size = Vector2(0, 50)
