extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rules2 = {
	"A" : {
		"wins_over": "Z",
		"draw_on": "X",
		"loose_to": "Y"
	},
	"B" : {
		"wins_over": "X",
		"draw_on": "Y",
		"loose_to": "Z"
	},
	"C" : {
		"wins_over": "Y",
		"draw_on": "Z",
		"loose_to": "X"
	},
	"X" : "wins_over",
	"Y" : "draw_on",
	"Z" : "loose_to"
}

var rules = {
	"X" : {
		"score": 1,
		"wins_over": "C",
		"draw_on": "A"
	},
	"Y" : {
		"score": 2,
		"wins_over": "A",
		"draw_on": "B"
	},
	"Z" : {
		"score": 3,
		"wins_over": "B",
		"draw_on": "C"
	}
}

var win_score = 6
var draw_score = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/OptionButton.add_item("test", 0)
	$HBoxContainer/OptionButton.add_item("puzzle", 1)
	$HBoxContainer/OptionButton.add_item("message", 2)
	
	$HBoxContainer/OptionButton.connect("item_selected", self, "_process_with_input")
	
	_process_with_input(0)

func _process_with_input(index):	
	var input_file = File.new()	
	input_file.open("res://input/2/"+$HBoxContainer/OptionButton.get_item_text(index)+".txt", File.READ)
	
	var score = 0
	var score2 = 0
	
	for game in input_file.get_as_text().split("\n"):
		var play = game.split(" ")[0]
		var answer = game.split(" ")[1]
		
		score += (rules[answer]["score"] + round_score(play, answer))
		score2 += round_score2(play, answer)
		
	$HBoxContainer/puzzle_1.text = str(score)
	$HBoxContainer/puzzle_2.text = str(score2)
		
func round_score(play, answer):
	if (rules[answer]["wins_over"] == play):
		return win_score
	if (rules[answer]["draw_on"] == play):
		return draw_score
	return 0
	
func round_score2(play, answer):
	var whatToPlay = rules2[play][rules2[answer]]
	return rules[whatToPlay]["score"] + round_score(play, whatToPlay)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
