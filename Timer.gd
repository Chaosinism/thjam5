extends Label

var seconds=30.0
var timer=.0

func _ready():
	seconds=30.0

func _physics_process(delta):
	text=str(stepify(seconds,0.1)).pad_decimals(1)
	if seconds>0:
		seconds-=delta
		
		timer+=delta
		if timer>1:
			get_parent().Schedule()
			timer=.0
	else:
		get_parent().GameOver()