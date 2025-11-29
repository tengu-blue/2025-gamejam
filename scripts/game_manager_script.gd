extends CanvasLayer


enum GameState { 
	Menu,
	
	Introduction, 
	FirstLevelExplain,
	
	FirstLevelPlay,
	
	PreSecondChoice,
	SecondLevelChoice,
	PostSecondLevelBeat,
	AllSecondLevelBeaten,
	
	PreThirdLevelChoice,
	ThirdLevelChoice,
	ThirdBeat,
	AllThirdBeaten,
	
	MidThird,
	
	PreFourth,
	Four,
	GiveUp,
	
	Won,
	
	End,
	
	PostEnd
	}

var nextState := {
	GameState.Menu : GameState.Introduction,
	
	GameState.Introduction : GameState.FirstLevelExplain,
	GameState.FirstLevelExplain : GameState.FirstLevelPlay,
	GameState.FirstLevelPlay : GameState.PreSecondChoice,
	
	GameState.PreSecondChoice : GameState.SecondLevelChoice,
	GameState.SecondLevelChoice : GameState.PostSecondLevelBeat,
	
	GameState.PostSecondLevelBeat : GameState.AllSecondLevelBeaten,
	
	GameState.AllSecondLevelBeaten : GameState.PreThirdLevelChoice,
	
	GameState.PreThirdLevelChoice : GameState.ThirdLevelChoice,
	GameState.ThirdLevelChoice : GameState.ThirdBeat,
	GameState.ThirdBeat : GameState.AllThirdBeaten,
	GameState.AllThirdBeaten : GameState.PreFourth,
	
	GameState.MidThird : GameState.ThirdLevelChoice,
	
	GameState.PreFourth : GameState.Four,
	GameState.Four : GameState.GiveUp,
	
	GameState.GiveUp : GameState.Won,
	
	GameState.Won : GameState.End,
	
	GameState.End : GameState.PostEnd
}
# the state determines what is visible and active etc.
var currentState := GameState.Menu

func advance_state():
	currentState = nextState[currentState]

# -------------------------------------------------------------------------

# The dialogs
# Who says it, what they say, once a section is over, trigger an event

var char1Name := "Oizys"
var char2Name := "Felicia"

var dialogIndex := 0
var lineIndex := 0

var dialogs := [
	[
		[1, "Hey, it’s so nice to see you again."],
		[2, "Hi! You too!"],
		[1, "It’s been a while. How are you?"],
		[2, "I’m... fine..."],
		[0, ""],
		[2, "I’m working on a videogame now. Hoping it’ll be very popular."],
		[1, "Oh. That’s awesome! Show me?"],
		[2, "Sure."]
	],
	[
		[2, "It’s work in progress, so the graphics aren’t finished yet."],
		[1, "Looks good, I think! So how do you play?"],
		[2, "Well it’s a platformer game. You move and jump around and your goal is to reach the end there."]
	],
	[
		[1, "Oh. That looks fun!"],
		[2, "Eh... Replaying it now, I think it’s way too easy."],
		[2, "Oh! I know I’m gonna add some..."]
	],
	[
		[2, "And maybe some..."]
	],
	[
		[1, "Well, I suck at hard games personally..." ],
		[2, "Oh, but people really like them. You know, the challenge is what makes it fun." ], 
		[2, "Overcoming it. It’s like real life!" ],
		[1, "..." ],
		[1, "right." ],
		[1, "Hey, how nice, it’s snowing outside. Do you wanna go out?" ],
		[2, "Nah. I feel like I’m really close now..." ]
	],
	[
		[1, "Hey the controls look a bit stiff?"],
		[2, "Yea, it makes it harder. But maybe I could make them a little worse?"],
		[1, "Okey... You sure?"],
		[2, "If it’s a little harder, it will be okay. Everything will be okay."],
		[1, "huh?"]
	],
	[
		[2, "And maybe some..."]
	],
	[
		[1, "Hey I think that’s pretty great. That seems like a satisfying challenge?" ],
		[2, "No..." ],
		[2, "Still not good enough." ],
		[2, "Gotta make it harder. That will solve everything." ],
		[1, "Solve? How do you mean?" ],
		[2, "..." ],
		[1, "..." ]
	],
	[
		[1, "Great job! I think that’s really impressive... Hey..."]
	],
	[
		[ 1, "Are you okay?"],
		[ 2, "I... "],
		[ 2, "..."],
		[ 2, "No..."],
		[ 2, "I..."],
		[ 2, "I think I need help..."],
		[ 2, "I thought that maybe if I made this game and it was really good..."],
		[ 2, "That... It would help... that I would be..."],
		[ 2, "happy... but..."],
		[ 1, "I think it’s brave to admit that. Better than acting bold, and pretending everything's fine..."],
		[ 1, "We all need some help sometimes. How about we take a break now and go enjoy the snow?"],
		[ 2, "..."],
		[ 2, "Yeah. Yeah I think that would be nice."],
		[ 2, "Thank you."],
	],
	
]

func hide_dialog() -> void:
	$DialogBody.visible = false

func show_dialog() -> void:
	# take the current indices and based on the index, show / hide images and show the text
	# TODO: check bounds etc.
	$DialogBody.visible = true
	
	var data = dialogs[dialogIndex][lineIndex]
	
	# TODO: show / hide the thingies
	print("Showing ", dialogIndex, ' ', lineIndex)
	$DialogBody/DialogWindow.text = data[1]
	
# -------------------------------------------------------------------------

func BeginGame() -> void:
	currentState = GameState.Introduction
	
	dialogIndex = 0
	lineIndex = 0
	
	applyState()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	applyState()

func level_beaten() -> void:
	match currentState:
		GameState.FirstLevelPlay:
			advance_state()
			applyState()
		
		GameState.SecondLevelChoice:
			show_dialog()
			show_available_options()
		
		GameState.ThirdLevelChoice:
			show_dialog()
			show_available_options()
		
		GameState.Four:
			$"/root/Level1".end_all()
			
			currentState = GameState.Won
			applyState()

func level_give_up() -> void:
	advance_dialog()
	currentState = GameState.End
	applyState()

func dialog_next() -> void:
	if currentState == GameState.Menu:
		return
	
	if currentState == GameState.FirstLevelPlay:
		return
	
	# have to pick from the options to advance
	if currentState == GameState.SecondLevelChoice:
		return
	
	
	# have to pick from the options to advance
	if currentState == GameState.ThirdLevelChoice:
		return
	
	if currentState == GameState.Four:
		return
	
	advance_dialog()

func advance_dialog():
	
	lineIndex += 1
	if lineIndex >= len(dialogs[dialogIndex]):
		dialogIndex += 1
		lineIndex = 0
		
		dialog_finished()
	else:
		show_dialog()

func dialog_finished() -> void:
	advance_state()
	applyState()

# -------------------------------------------------------------------------

var used_options := []

# keep track of used / available
func show_available_options() -> void:
	
	if currentState == GameState.SecondLevelChoice and len(used_options) >= 3:
		used_options.clear()
		currentState = GameState.AllSecondLevelBeaten
		applyState()
		return
	
	if currentState == GameState.ThirdLevelChoice and len(used_options) >= 3:
		used_options.clear()
		currentState = GameState.AllThirdBeaten
		applyState()
		return
	
	if currentState == GameState.ThirdLevelChoice and len(used_options) == 1:
		currentState = GameState.MidThird
		applyState()
		used_options.append("buffer")
		return
	
	if currentState == GameState.SecondLevelChoice:
		$Spikes.visible = !used_options.has("spikes")
		$Pits.visible = !used_options.has("pits")
		$Platforms.visible = !used_options.has("platforms")
	
	if currentState == GameState.ThirdLevelChoice:
		$Sawblade.visible = !used_options.has("sawblade")
		$Pikes.visible = !used_options.has("pikes")

func hide_options() -> void:
	$Spikes.visible = false
	$Pits.visible = false
	$Platforms.visible = false
	$Sawblade.visible = false
	$Pikes.visible = false


func option_spikes() -> void:
	used_options.append("spikes")
	$"/root/Level1".show_layer("spikes")	
	hide_options()
	hide_dialog()

func option_pits() -> void:
	used_options.append("pits")
	$"/root/Level1".show_layer("pits")
	hide_options()	
	hide_dialog()

func option_platforms() -> void:
	used_options.append("platforms")
	$"/root/Level1".show_layer("platforms")
	hide_options()
	hide_dialog()


func option_sawblades() -> void:
	used_options.append("sawblade")
	$"/root/Level1".show_layer("sawblade")
	hide_options()
	hide_dialog()

func option_pikes() -> void:
	used_options.append("pikes")
	$"/root/Level1".show_layer("pikes")
	hide_options()
	hide_dialog()

# -------------------------------------------------------------------------


func applyState() -> void:
	
	print("Applying ", currentState)
	
	match currentState:
		GameState.Menu:
			hide_dialog()
			hide_options()
			dialogIndex = 0
			lineIndex = 0
			$GiveUp.visible = false
		
		GameState.Introduction:
			show_dialog()
		
		GameState.FirstLevelExplain:
			# Load the level and play the next dialog
			get_tree().change_scene_to_file("res://scenes/Level1.tscn")
			show_dialog()
		
		GameState.FirstLevelPlay:
			hide_dialog()
			
		GameState.PreSecondChoice:
			show_dialog()
		
		GameState.SecondLevelChoice:
			show_available_options()
		
		GameState.AllSecondLevelBeaten:
			hide_dialog()
			advance_dialog()
		
		GameState.PreThirdLevelChoice:
			show_dialog()
		
		GameState.ThirdLevelChoice:
			show_available_options()
		
		GameState.AllThirdBeaten:
			hide_dialog()
			advance_dialog()
		
		GameState.MidThird:
			lineIndex = 0
			show_dialog()

		GameState.PreFourth:
			show_dialog()
		
		GameState.Four:
			hide_dialog()
			$"/root/Level1".show_layer("hardest")	
			$GiveUp.visible = true
		
		GameState.Won:
			show_dialog()
			$GiveUp.visible = false
		
		GameState.End:
			show_dialog()
			$GiveUp.visible = false
		
		GameState.PostEnd:
			hide_dialog()
			# load thank you screen (with ending message) / menu
			get_tree().change_scene_to_file("res://scenes/EndScene.tscn")
		_:
			$DialogBody.visible = true
				
	pass
