extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/OptionButton.add_item("test", 0)
	$HBoxContainer/OptionButton.add_item("puzzle", 1)
	#$HBoxContainer/OptionButton.add_item("message", 2)
	
	$HBoxContainer/OptionButton.connect("item_selected", self, "_process_with_input")
	
	_process_with_input(0)
	
func _process_with_input(index):	
	var input_file = File.new()	
	input_file.open("res://input/6/"+$HBoxContainer/OptionButton.get_item_text(index)+".txt", File.READ)
	
	var textFile = input_file.get_as_text()
	
	
	$HBoxContainer/puzzle_1.text = str(_find_char(textFile, 4))
	$HBoxContainer/puzzle_2.text = str(_find_char(textFile, 14))
	
func _find_char(text, nbCharUnique):
	var position = nbCharUnique
	var found_position = false
	
	var i = 0
	while i <= text.length()-4:
		var found_twice = false
		var stringToAnalyse = text.substr(i, nbCharUnique)
		for character in stringToAnalyse:
			if stringToAnalyse.count(character, 0, stringToAnalyse.length()) > 1:
				found_twice = true		
		if !found_twice && !found_position:
			position += i
			break
		i+=1
	return position
