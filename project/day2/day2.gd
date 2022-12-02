extends Control

onready var animationPlayer = $VBoxContainer/ReferenceRect/AnimationPlayer
onready var optionMenu = $VBoxContainer/HBoxContainer/OptionButton

var pierreResource = preload("res://day2/assets/pierre.png")
var feuilleResource = preload("res://day2/assets/feuille.png")
var ciseauResource = preload("res://day2/assets/ciseau.png")

var play_animation = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var images = {
	"A":pierreResource,
	"B":feuilleResource,
	"C":ciseauResource,
	"X":pierreResource,
	"Y":feuilleResource,
	"Z":ciseauResource
}

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
	$VBoxContainer/HBoxContainer/playAnimation.pressed = play_animation
	$VBoxContainer/ReferenceRect.visible = play_animation
	$VBoxContainer/HBoxContainer/playAnimation.connect("toggled", self, "_show_player")
	
	optionMenu.add_item("test", 0)
	optionMenu.add_item("puzzle", 1)
	optionMenu.add_item("message", 2)
	
	optionMenu.connect("item_selected", self, "_process_with_input")
	
	_process_with_input(0)

func _process_with_input(index):	
	var input_file = File.new()	
	input_file.open("res://input/2/"+optionMenu.get_item_text(index)+".txt", File.READ)
	
	var score = 0
	var score2 = 0
	
	for game in input_file.get_as_text().split("\n"):
		var play = game.split(" ")[0]
		var answer = game.split(" ")[1]
		
		if (play_animation):
			animationPlayer.play("before_play")
	#		var anim: Animation = animationPlayer.get_animation("before_play")
			
			yield(animationPlayer, "animation_finished")
			
			get_node("%Play").texture = images[play]
			get_node("%Answer").texture = images[answer]
			
			var t = Timer.new()
			t.wait_time = 0.5
			t.one_shot = true
			add_child(t)
			t.start()
			yield(t, "timeout")	
		
		score += (rules[answer]["score"] + round_score(play, answer))
		score2 += round_score2(play, answer)
		
		$VBoxContainer/ReferenceRect/TextEdit.text = str(score2)
		
		
		
	$VBoxContainer/HBoxContainer/puzzle_1.text = str(score)
	$VBoxContainer/HBoxContainer/puzzle_2.text = str(score2)
		
func round_score(play, answer):
	if (rules[answer]["wins_over"] == play):
		return win_score
	if (rules[answer]["draw_on"] == play):
		return draw_score
	return 0
	
func round_score2(play, answer):
	var whatToPlay = rules2[play][rules2[answer]]
	return rules[whatToPlay]["score"] + round_score(play, whatToPlay)
	
func _show_player(checked):
	$VBoxContainer/ReferenceRect.visible = checked
	play_animation = checked

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
