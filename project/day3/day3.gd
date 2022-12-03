extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var alphabetArray = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/OptionButton.add_item("test", 0)
	$HBoxContainer/OptionButton.add_item("puzzle", 1)
	
	$HBoxContainer/OptionButton.connect("item_selected", self, "_process_with_input")
	
	_process_with_input(0)
	
func _process_with_input(index):	
	var input_file = File.new()	
	input_file.open("res://input/3/"+$HBoxContainer/OptionButton.get_item_text(index)+".txt", File.READ)
	
	var foundLetters = []
	
	var ruckSacks = input_file.get_as_text().split("\n")
	
	# ---- Part 1 ----
	for ruckSack in ruckSacks:

		var firstComp = ruckSack.substr(0, ruckSack.length()/2)
		var secondComp = ruckSack.substr(ruckSack.length()/2, ruckSack.length())

		for letter in firstComp:
			if secondComp.find(letter, 0) != -1:
				foundLetters.append(letter)
				break
	
	# ---- Part 2 ----
	var i = 0
	var foundLetters2 = []
	while (i+2 < ruckSacks.size()):
		
		var firstSack = ruckSacks[i]
		var secondSack = ruckSacks[i+1]
		var thirdSack = ruckSacks[i+2]
		
		for letter in firstSack:
			if secondSack.find(letter, 0) != -1 && thirdSack.find(letter, 0) != -1:
				foundLetters2.append(letter)
				break
		i += 3
				
				
	var score = _compute_score(foundLetters)
	$HBoxContainer/puzzle_1.text = str(score)
	
	var score2 = _compute_score(foundLetters2)
	$HBoxContainer/puzzle_2.text = str(score2)
	
func _compute_score(letterArray):
	var score = 0
	for letter in letterArray:
		var addedScore = 0
		if letter == letter.to_lower():
			addedScore += alphabetArray.find(letter, 0)+1
		else:
			addedScore += alphabetArray.find(letter.to_lower(), 0)+27
		score += addedScore
	return score
