extends Control


func _on_ButtonEasy_pressed():
	SelectionFinished(0)


func _on_ButtonHard_pressed():
	SelectionFinished(2)


func _on_ButtonLunatic_pressed():
	SelectionFinished(3)


func _on_ButtonNormal_pressed():
	SelectionFinished(1)
	
func SelectionFinished(d):
	get_parent().get_node('Main').difficulty=d
	get_parent().get_node('Main').SpawnMenu(d)
	queue_free()
