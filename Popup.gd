extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _physics_process(delta):
	rect_position[1]-=33*delta
	modulate[3]-=.66*delta
	if modulate[3]<=0:
		queue_free()
		get_parent().CheckStatus()