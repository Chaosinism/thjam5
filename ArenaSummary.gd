extends Control

var score=1
var performerName='Meiling'
var comments=['Awful','Bad','Good','Great','Perfect']

# Called when the node enters the scene tree for the first time.
func _ready():
	if score<2:
		$Particle3.hide()
	if score<1:
		$Particle2.hide()
	if score<0:
		$Particle1.hide()
	$Result.text=comments[score+2]
	
	var description=performerName+"'s prestige "
	if score==0:
		description+='remains the same.'
	elif score>0:
		description+='is increased by '+str(abs(score))+' .'
	else:
		description+='is decreased by '+str(abs(score))+' .'
	$Description.text=description

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

		

func _on_Button_pressed():
	queue_free()
	get_parent().get_node('Menu').engagedResult=score
	get_parent().get_node('Menu').CheckStatus()
