extends Control

var life=1

func Refresh():
	if life>0:
		$Life1.visible=true
	else:
		$Life1.visible=false
	if life>1:
		$Life2.visible=true
	else:
		$Life2.visible=false
	if life>2:
		$Life3.visible=true
	else:
		$Life3.visible=false

func _ready():
	Refresh()

func Hit():
	life-=1
	Refresh()
	if life<0:
		get_parent().GameOver()


