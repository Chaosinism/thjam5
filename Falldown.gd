extends AnimatedSprite

func _ready():
	position[1]-=100
	modulate[3]=0
	
func _process(delta):
	if modulate[3]<1:
		position[1]+=100*delta
	if modulate[3]<2:
		modulate[3]+=1*delta
	else:
		#queue_free()
		get_parent().CheckStatus()		
		set_process(false)