extends Button

func _ready() -> void:
	grab_focus()

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Blank.tscn")
	GameManager.BeginGame()
