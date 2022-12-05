extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/OptionButton.add_item("test", 0)
	$HBoxContainer/OptionButton.add_item("puzzle", 1)
	$HBoxContainer/OptionButton.add_item("message", 2)
	
	$HBoxContainer/OptionButton.connect("item_selected", self, "_process_with_input")
	
	_process_with_input(0)
	
func _process_with_input(index):	
	var input_file = File.new()	
	input_file.open("res://input/5/"+$HBoxContainer/OptionButton.get_item_text(index)+".txt", File.READ)
	
	var textFile = input_file.get_as_text().split("\n")
	# ---- Construction des stacks de départ ----
	var stacks = []
	
	var i = 0
	while i<textFile.size() && !textFile[i].begins_with(" 1"):
		var position = 0
		for j in range(0, textFile[i].length(), 4):
			if stacks.size() <= position:
				stacks.append("")
			if (textFile[i][j] != " "):
				stacks[position] = str(textFile[i][j+1], stacks[position])
			position += 1
		i += 1
	
	i += 2
	
	var stacks2 = stacks.duplicate()
	
	# ---- Mouvement des caisses ----
	while i < textFile.size():				
		var nbToMove = int(textFile[i].split(" ")[1])
		var from = int(textFile[i].split(" ")[3])-1
		var to = int(textFile[i].split(" ")[5])-1
		
		for j in range(nbToMove, 0, -1):
			var toMove = stacks[from].right(stacks[from].length()-1)
			stacks[from] = stacks[from].left(stacks[from].length()-1)				
			stacks[to] = stacks[to]+ toMove
			
		var toMove2 = stacks2[from].right(stacks2[from].length()-nbToMove)
		stacks2[from] = stacks2[from].left(stacks2[from].length()-nbToMove)				
		stacks2[to] = stacks2[to]+ toMove2
		
		i+=1
	
	
	$HBoxContainer/puzzle_1.text = str(build_answer(stacks))
	$HBoxContainer/puzzle_2.text = str(build_answer(stacks2))

func build_answer(array):
	var answer = ""
	for string in array:
		if string.length() == 0:
			answer = answer + " "
		else:
			answer = answer+string.substr(string.length()-1)
	return answer
