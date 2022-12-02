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
	input_file.open("res://input/1/"+$HBoxContainer/OptionButton.get_item_text(index)+".txt", File.READ)
	
	var maxCal = 0
	var calList = []
	var currentCal = 0
	
	for value in input_file.get_as_text().split("\n"):
		if value == "":
			if maxCal<currentCal:
				maxCal=currentCal
			calList.append(currentCal)
			currentCal = 0
		else:
			currentCal += int(value)
			
	if maxCal<currentCal:
				maxCal=currentCal
	
	calList.append(currentCal)
	
	calList.sort_custom(MyCustomSort, "sort_descending")
	
	$HBoxContainer/puzzle_1.text = str(maxCal)
	$HBoxContainer/puzzle_2.text = str(calList[0]+calList[1]+calList[2])
	
class MyCustomSort:
	static func sort_descending(a, b): # Par premier élément croissant
		if a > b:
			return true
		return false



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
