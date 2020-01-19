extends Button

func _pressed():
	get_parent().queue_free()
	get_parent().get_parent().get_node('Main').SelectDifficulty()
