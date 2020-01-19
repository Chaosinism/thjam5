extends Timer

var index=0

func _ready():
	pass # Replace with function body.

func timeout():
	pass

func _on_ParticleTimer_timeout():
	index+=1
	if index==1:
		get_parent().get_node('Particle1').emitting=true
		get_parent().get_node('Particle1').restart()
		start(.5)
	if index==2:
		get_parent().get_node('Particle2').emitting=true
		get_parent().get_node('Particle2').restart()
		start(.5)
	if index==3:
		get_parent().get_node('Particle3').emitting=true
		get_parent().get_node('Particle3').restart()