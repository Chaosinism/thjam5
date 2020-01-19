extends Sprite

# 20 - great, 40 - perfect
var score=0

func _ready():
	pass
	
func Worse():
	score-=4
	get_parent().get_node("Audio_Down").play()
	Refresh()
	
func Better():
	score+=.7
	get_parent().get_node("Audio_Up").play()
	Refresh()	
	
func Refresh():
	score=clamp(score,-48,48)
	$Marker.position[0]=score*6
	if score<=-20:
		$Marker.animation='negative'
	elif score>=20:
		$Marker.animation='positive'
	else:
		$Marker.animation='neutral'
