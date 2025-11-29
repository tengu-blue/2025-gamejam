extends CanvasLayer


enum GameState { 
	Menu,
	
	Introduction, 
	FirstLevelExplain,
	
	FirstLevelPlay,
	
	SecondLevelChoice,
	PostSecondLevelBeat,
	AllSecondLevelBeaten,
	
	ThirdLevelChoice,
	ThirdBeat,
	AllThirdBeaten,
	
	Fourth,
	GiveUp,
	
	Won,
	
	End
	}

var nextState := {
	GameState.Menu : GameState.Introduction,
	
	GameState.Introduction : GameState.FirstLevelExplain,
	GameState.FirstLevelExplain : GameState.FirstLevelPlay,
	GameState.FirstLevelPlay : GameState.SecondLevelChoice,
	
	GameState.SecondLevelChoice : GameState.PostSecondLevelBeat,
	GameState.PostSecondLevelBeat : GameState.AllSecondLevelBeaten,
	GameState.AllSecondLevelBeaten : GameState.ThirdLevelChoice,
	
	GameState.ThirdLevelChoice : GameState.ThirdBeat,
	GameState.ThirdBeat : GameState.AllThirdBeaten,
	GameState.AllThirdBeaten : GameState.Fourth,
	
	GameState.Fourth : GameState.GiveUp,
	GameState.GiveUp : GameState.Won,
	
	GameState.Won : GameState.End,
	
	GameState.End : GameState.Menu
}
# the state determines what is visible and active etc.
var currentState := GameState.Menu
# counter for inside state stuff
var currentStateUtilCounter := 0

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
		
	]
]

func hide_dialog() -> void:
	$DialogBody.visible = false

func show_dialog() -> void:
	# take the current indices and based on the index, show / hide images and show the text
	# TODO: check bounds etc.
	$DialogBody.visible = true
	
	var data = dialogs[dialogIndex][lineIndex]
	
	# TODO: show / hide the thingies
	
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
		
		# In later ones, increment counter and based on it do other stuff
	
func player_die() -> void:
	pass

func dialog_next() -> void:
	# have to pick from the options to advance
	if currentState == GameState.SecondLevelChoice and lineIndex+1 == len(dialogs[dialogIndex]):
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

func applyState() -> void:
	
	match currentState:
		GameState.Menu:
			hide_dialog()
		
		GameState.Introduction:
			show_dialog()
		
		GameState.FirstLevelExplain:
			# Load the level and play the next dialog
			get_tree().change_scene_to_file("res://scenes/Level1.tscn")
			show_dialog()
		
		GameState.FirstLevelPlay:
			hide_dialog()
		
		GameState.SecondLevelChoice:
			show_dialog()
		
		_:
			$DialogBody.visible = true
				
	pass
