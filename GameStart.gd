extends Button

func _pressed():
	disabled=true
	get_parent().StartGame()