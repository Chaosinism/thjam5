extends Node2D
var Summary = preload("res://ArenaSummary.tscn")
var Hint = preload("res://Hint.tscn")

var Fairy = preload("res://Fairy.tscn")
var Meiling = preload("res://Meiling.tscn")
var Junko = preload("res://Junko.tscn")
var Seiga = preload("res://Seiga.tscn")
var Yachie = preload("res://Yachie.tscn")

# parameters of MC
var extraLife=2
var extraRange=1

# parameters of Yachie
var opponentIntention=0    # 0 - not present, 1 - attack the performer, 2 - attack audience
var opponentLevel=3
var opponent=null

# parameters of the performer
var performerList={'Meiling':Meiling,'Junko':Junko,'Seiga':Seiga}
var performerName='Meiling'
var performer= null
var performerLevel=4

var fairies=[]

var status=0    # 0 - move, 1 - shoot
var performerLocation=0

var hint=true

func _ready():
	randomize()
	
	# music
	get_parent().get_node('Main').AudioFadeIn(performerName)

	
	# MC
	$LifeBar.life=1+extraLife
	$LifeBar.Refresh()
	$Reimu.shootingRange=.4+.1*extraRange
	
	# spawn audience
	for i in range(3):
		SpawnFairy()

	# spawn performer
	if performerName in performerList:
		performer=performerList[performerName].instance()
		performer.position=$CenterAnchor.position
		performer.targetPosition=$CenterAnchor.position
		add_child(performer)
		
	# spawn Yachie
	if opponentIntention!=0:
		var x=$SpawnAnchor.position[0] + randi()% int($SpawnAnchor2.position[0]-$SpawnAnchor.position[0])
		var y=$SpawnAnchor.position[1] + randi()% int($SpawnAnchor2.position[1]-$SpawnAnchor.position[1])
		while Vector2(x,y).distance_to($Reimu.position)<200:
			x=$SpawnAnchor.position[0] + randi()% int($SpawnAnchor2.position[0]-$SpawnAnchor.position[0])
			y=$SpawnAnchor.position[1] + randi()% int($SpawnAnchor2.position[1]-$SpawnAnchor.position[1])
		opponent=Yachie.instance()
		opponent.position=Vector2(x,y)
		opponent.level=opponentLevel
		add_child(opponent)
		
		if opponentIntention==1:
			opponent.target=performer
		else:
			YachieTargeting()
			
	if hint==true:
		Engine.time_scale = 0.0
		add_child(Hint.instance())

var shortest=65535
func YachieTargeting():
	for fairy in fairies:
		if fairy.status==0:
			opponent.target=fairy
			shortest=fairy.position.distance_to(opponent.position)
			break
			
	for fairy in fairies:
		if fairy.status==0 and fairy.position.distance_to(opponent.position)<shortest:
			shortest=fairy.position.distance_to(opponent.position)
			opponent.target=fairy
			

func SpawnFairy():
	var x=$SpawnAnchor.position[0] + randi()% int($SpawnAnchor2.position[0]-$SpawnAnchor.position[0])
	var y=$SpawnAnchor.position[1] + randi()% int($SpawnAnchor2.position[1]-$SpawnAnchor.position[1])
	while Vector2(x,y).distance_to($Reimu.position)<100:
		x=$SpawnAnchor.position[0] + randi()% int($SpawnAnchor2.position[0]-$SpawnAnchor.position[0])
		y=$SpawnAnchor.position[1] + randi()% int($SpawnAnchor2.position[1]-$SpawnAnchor.position[1])
	var fairy=Fairy.instance()
	fairy.position=Vector2(x,y)
	fairies.append(fairy)
	add_child(fairy)

func FairyDied(fairy):
	if opponentIntention==2:
		opponent.target=opponent
		YachieTargeting()
	
func Schedule():
	status+=1
	
	# performer movement
	if status%2==0:
		if performerLocation==0:
			performerLocation=randi()%2*2-1
		else:
			performerLocation=0
		performer.targetPosition[0]=150*performerLocation+$CenterAnchor.position[0]
		
	# performer attack
	elif status%2==1:
		performer.Attack(performerLevel)
		$Audio_Explode.play()
		
func GameOver():
	var score=$PopBar.score/20.0
	if score>0:
		score=floor(score)
	else:
		score=ceil(score)
	var summary=Summary.instance()
	summary.score=score
	summary.performerName=performerName
	get_parent().add_child(summary)
	queue_free()
		
	