extends Control

onready var optionMenu = $VBoxContainer/HBoxContainer/OptionButton

var play_animation = false

class ArboItem: 
	var name: String
	var size: int
	var children: Array
	var parent: ArboItem

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
	input_file.open("res://input/7/"+optionMenu.get_item_text(index)+".txt", File.READ)
	
	var arboRoot = ArboItem.new()
	arboRoot.name = "/"
	arboRoot.children = []
	var currentItem: ArboItem = arboRoot
	
	for line in input_file.get_as_text().split("\n", false):
		var lineString: = line as String
		if lineString.begins_with("$"):
			if lineString.split(" ")[1] == "cd":
				if lineString.split(" ")[2] == "..":
					currentItem = currentItem.parent
				else:
					var childToGo
					for child in currentItem.children:
						if child.name == lineString.split(" ")[2]:
							childToGo = child
							break
					currentItem = childToGo
			else: #ls case
				continue
		else:
			var itemToCreate = ArboItem.new()
			if lineString.begins_with("dir"):					
				itemToCreate.name =lineString.split(" ")[1]
			else:
				itemToCreate.name = lineString.split(" ")[1]
				itemToCreate.size = int(lineString.split(" ")[0])
			itemToCreate.parent = currentItem
			currentItem.children.append(itemToCreate)
	
	_process_arbo_size(arboRoot)
	
	#part 2
	var spaceFreeNeeded = arboRoot.size - 40000000
		
	$VBoxContainer/HBoxContainer/puzzle_1.text = str(_answer_1(arboRoot))
	$VBoxContainer/HBoxContainer/puzzle_2.text = str(_answer_2(arboRoot, arboRoot.size, spaceFreeNeeded))
	
func _answer_2(arboRoot: ArboItem, previousSize: int, spaceFreeNeeded: int)-> int:
	if (arboRoot.children.size() == 0):
		return previousSize
	if (arboRoot.size < previousSize && arboRoot.size >= spaceFreeNeeded):
		previousSize = arboRoot.size
	for child in arboRoot.children:
		previousSize = _answer_2(child, previousSize, spaceFreeNeeded)
	return previousSize
	
func _answer_1(arboRoot: ArboItem) -> int:
	var result = 0
	if (arboRoot.children.size() == 0):
		return 0
	if arboRoot.size <= 100000:
		result += arboRoot.size
	for child in arboRoot.children:
		result += _answer_1(child)
	return result
	
	
func _process_arbo_size(arboRoot: ArboItem)-> int:
	if (arboRoot.children.size() == 0):
		return arboRoot.size
	for child in arboRoot.children:
		arboRoot.size += _process_arbo_size(child)
	return arboRoot.size
	
func _show_player(checked):
	$VBoxContainer/ReferenceRect.visible = checked
	play_animation = checked
	if checked:
		self.rect_min_size = Vector2(0, 250)
	else:
		self.rect_min_size = Vector2(0, 50)
