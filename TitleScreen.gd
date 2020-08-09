extends Node



func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/StartButton.grab_focus()


func _phyisics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/StartButton.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/StartButton.grab_focus()
#	if $MarginContainer/VBoxContainer/VBoxContainer/CreditsButton.is_hovered():
#		$MarginContainer/VBoxContainer/VBoxContainer/CreditsButton.grab_focus()
#	if $MarginContainer/VBoxContainer/VBoxContainer/ControlsButton.is_hovered():
#		$MarginContainer/VBoxContainer/VBoxContainer/ControlsButton.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/QuitButton.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/QuitButton.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/LevelTemplate.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
