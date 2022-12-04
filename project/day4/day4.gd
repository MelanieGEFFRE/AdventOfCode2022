extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/OptionButton.add_item("test", 0)
	$HBoxContainer/OptionButton.add_item("puzzle", 1)
	
	$HBoxContainer/OptionButton.connect("item_selected", self, "_process_with_input")
	
	_process_with_input(0)
	
func _process_with_input(index):	
	var input_file = File.new()	
	input_file.open("res://input/4/"+$HBoxContainer/OptionButton.get_item_text(index)+".txt", File.READ)
	
	var nbFullOverlap = 0
	var nbOverlap = 0
	
	for line in input_file.get_as_text().split("\n"):
		var areasCOvered = line.split(",")
		var start1 = int(areasCOvered[0].split("-")[0])
		var end1 = int(areasCOvered[0].split("-")[1])
		var start2 = int(areasCOvered[1].split("-")[0])
		var end2 = int(areasCOvered[1].split("-")[1])
		
		if (start1 <= start2 && end1 >= end2) || (start2 <= start1 && end2 >= end1):
			nbFullOverlap += 1
			
		if (start1 >= start2 && start1 <= end2) || (end1 >= start2 && end1 <= end2) || (start1 <= start2 && end1 >= end2) || (start2 <= start1 && end2 >= end1):
			print(str(start1, ", ", end1, " - ", start2, ", ", end2))
			nbOverlap += 1
			
	$HBoxContainer/puzzle_1.text = str(nbFullOverlap)
	$HBoxContainer/puzzle_2.text = str(nbOverlap)
