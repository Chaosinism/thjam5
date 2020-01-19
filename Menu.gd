extends Control

var Popup = preload("res://Popup.tscn")
var Falldown = preload("res://Falldown.tscn")
var Arena = preload("res://Arena.tscn")
var Ending = preload("res://GameOver.tscn")

var day=1
var phase=0

var performerName=['Meiling','Seiga','Junko']
var prestige=[3,3,3]
var mcStake=[1,1,1]
var opStake=[1,1,1]
var performerExp=[-1,-1,-1]
var opExp=-1
var healthLevel=1
var rangeLevel=1
var mcCash=1000
var opCash=1000

var mcEngaged=0
var opEngaged=0
var mcIndicator=null
var opIndicator=null
var engagedResult=0

var forAI=null

onready var phaseText=get_node('DynamicElements/Phase')
onready var tipText=get_node('DynamicElements/Tips')

onready var prestigeText=[get_node('DynamicElements/MeilingPrestige'),get_node('DynamicElements/SeigaPrestige'),get_node('DynamicElements/JunkoPrestige')]
onready var priceText=[get_node('DynamicElements/MeilingPrice'),get_node('DynamicElements/SeigaPrice'),get_node('DynamicElements/JunkoPrice')]
onready var mcStakeText=[get_node('DynamicElements/MeilingBid1'),get_node('DynamicElements/SeigaBid1'),get_node('DynamicElements/JunkoBid1')]
onready var opStakeText=[get_node('DynamicElements/MeilingBid2'),get_node('DynamicElements/SeigaBid2'),get_node('DynamicElements/JunkoBid2')]
onready var buyButton=[get_node('DynamicElements/MeilingBuy'),get_node('DynamicElements/SeigaBuy'),get_node('DynamicElements/JunkoBuy')]
onready var sellButton=[get_node('DynamicElements/MeilingSell'),get_node('DynamicElements/SeigaSell'),get_node('DynamicElements/JunkoSell')]
onready var battleButton=[get_node('DynamicElements/MeilingBattle'),get_node('DynamicElements/SeigaBattle'),get_node('DynamicElements/JunkoBattle')]

onready var buyHealth=get_node('DynamicElements/BuyHealth')
onready var buyRange=get_node('DynamicElements/BuyRange')
onready var healthText=get_node('DynamicElements/EquipHealth')
onready var rangeText=get_node('DynamicElements/EquipRange')

onready var skipButton=get_node('DynamicElements/Skip')

onready var mcCashText=get_node('DynamicElements/Cash')
onready var opCashText=get_node('DynamicElements/Cash2')

func _ready():
	randomize()
	phase=0
	CheckStatus()
	
func _process(delta):
	UpdateLabels()
	UpdateButtons()
	
func BattleStart():
	hide()
	var arena=Arena.instance()
	arena.extraLife=healthLevel-1
	arena.extraRange=rangeLevel-1
	
	if mcEngaged==opEngaged:
		arena.opponentIntention = int(mcStake[mcEngaged]>opStake[mcEngaged])+1
		opExp+=1
	arena.opponentLevel=min(opExp,4)
	
	performerExp[mcEngaged]+=1
	arena.performerName=performerName[mcEngaged]
	arena.performerLevel=min(int(performerExp[mcEngaged]/2)+1,4)
	
	get_parent().add_child(arena)
	
func BattleSettle(i):
	
	var delta=0
	if i==mcEngaged:
		delta+=engagedResult
	elif i==opEngaged:
		var attitude = int(mcStake[i]<opStake[i])*2-1
		var p=randi()%100
		if p<30:
			delta+=attitude*2
		else:
			delta+=attitude
	else:
		delta+=randi()%3-1
	prestige[i]+=delta
	prestige[i]=clamp(prestige[i],1,9)
	
	var pop=Popup.instance()
	if delta<0:
		pop.text=str(delta)
	else:
		pop.text='+'+str(delta)
	pop.rect_position=prestigeText[i].rect_position
	pop.rect_position[0]+=75
	add_child(pop)		

func UpdateLabels():
	for i in range(3):
		prestigeText[i].text=str(prestige[i])+' / 9'
		priceText[i].text='$ '+str(prestige[i]*100)
		mcStakeText[i].text=str(mcStake[i])
		opStakeText[i].text=str(opStake[i])
	healthText.text='Extra Health Point\n'+str(healthLevel)+' / 3'
	rangeText.text='Extra Attack Range\n'+str(rangeLevel)+' / 3'
	mcCashText.text='Your Cash:\n$ '+str(mcCash)
	opCashText.text="Yachie's Cash:\n$ "+str(opCash)
			
func UpdateButtons():
	for i in range(3):
		buyButton[i].disabled= mcCash<prestige[i]*100
		sellButton[i].disabled= mcStake[i]<1
	buyRange.disabled= mcCash<200 or rangeLevel>2
	buyHealth.disabled= mcCash<200 or healthLevel>2

func CheckStatus():
	# phase 1,2,3: player transaction;
	# phase 4,5,6: AI transaction;
	# phase 7,8: choose target;
	# phase 9: battle;
	# phase 10,11,12: handle battle results
	
	phase+=1
	#UpdateLabels()
	#UpdateButtons()	

	if phase==1:
		$AvatarReimu.modulate=Color(1,1,1,1)
		$AvatarYachie.modulate=Color(1,1,1,0.5)
		forAI=[[mcStake[0],mcStake[1],mcStake[2]],[opStake[0],opStake[1],opStake[2]]]
		for i in range(3):
			buyButton[i].show()
			sellButton[i].show()
			battleButton[i].hide()
		buyRange.show()
		buyHealth.show()
		skipButton.show()
		
	if phase==4:
		$AvatarReimu.modulate=Color(1,1,1,0.5)
		$AvatarYachie.modulate=Color(1,1,1,1)	
		phaseText.text="Yachie is having her turn..."
		for i in range(3):
			buyButton[i].hide()
			sellButton[i].hide()
		buyRange.hide()
		buyHealth.hide()
		skipButton.hide()	
		
	if phase==7:
		$AvatarReimu.modulate=Color(1,1,1,1)
		$AvatarYachie.modulate=Color(1,1,1,1)
		for i in range(3):
			battleButton[i].show()
		phaseText.text='Night '+str(day)+'/10 - Fireworks Show'
		tipText.text="Choose a fireworks show to attend. Your action may impact the result. A successful show will bring more prestiges to the performer (and therefore bring money to you)."
		
	if phase in [1,2,3]:
		phaseText.text='Day '+str(day)+'/10 - Transaction '+str(phase)+'/3'
		tipText.text="Everyday, you can make 3 transactions. A performer's stake price will increase with her prestige. Try to earn as much money as possible in 10 days by purchasing and selling stakes."
	
	if phase in [4,5,6]:
		AI_1()
		
	if phase==8:
		AI_2()
		
	if phase==9:
		BattleStart()
		
	if phase in [10,11,12]:
		show()
		BattleSettle(phase-10)
		
	if phase==13:
		day+=1
		phase=0
		mcIndicator.queue_free()
		opIndicator.queue_free()
		if day>10:
			GameOver()
		else:
			CheckStatus()


func AI_1():
	# sell when money is not enough
	if opCash<prestige[0]*100 and opCash<prestige[1]*100 and opCash<prestige[2]*100:
		var candidate=-1
		var temp=-1
		for i in range(3):
			if opStake[i]>0 and prestige[i]>temp:
				candidate=i
				temp=prestige[i]
		if candidate==-1:
			AISkip()
		else:
			AISell(candidate)

	# otherwise buy
	else:
		var weights=[0,0,0]
		for i in range(3):
			if opCash>prestige[i]*100:
				weights[i]=9-prestige[i]
		if weights[0]+weights[2]+weights[1]==0:
			AISkip()
			return
		var p=randi()%int(weights[0]+weights[1]+weights[2])
		if p<weights[0]:
			AIBid(0)
		elif p<weights[0]+weights[1]:
			AIBid(1)
		else:
			AIBid(2)

func AI_2():
	var weights=[0,0,0]
	for i in range(3):
		weights[i]=abs(mcStake[i]-opStake[i])
	if weights[0]+weights[2]+weights[1]==0:
		weights[0]=1
	var p=randi()%int(weights[0]+weights[1]+weights[2])
	if p<weights[0]:
		AIBattle(0)
	elif p<weights[0]+weights[1]:
		AIBattle(1)
	else:
		AIBattle(2)		

func Bid(i):
	if phase<4:
		mcCash-=prestige[i]*100
		mcStake[i]+=1
		$AudioMoney.play()
		CheckStatus()
	
func Sell(i):
	if phase<4:
		mcCash+=prestige[i]*100
		mcStake[i]-=1
		$AudioMoney.play()
		CheckStatus()
		
func Battle(i):
	if phase==7:
		mcEngaged=i
		mcIndicator=Falldown.instance()
		mcIndicator.animation='reimu'
		mcIndicator.position=battleButton[i].rect_position
		mcIndicator.position[0]+=20
		add_child(mcIndicator)
		
		for i in range(3):
			battleButton[i].hide()

func AIBid(i):
	opCash-=prestige[i]*100
	opStake[i]+=1
	var pop=Popup.instance()
	pop.text='+1'
	pop.rect_position=opStakeText[i].rect_position
	pop.rect_position[0]+=75
	add_child(pop)
	$AudioMoney.play()
	
func AISell(i):
	opCash+=prestige[i]*100
	opStake[i]-=1
	var pop=Popup.instance()
	pop.text='-1'
	pop.rect_position=opStakeText[i].rect_position
	pop.rect_position[0]+=75
	add_child(pop)
	$AudioMoney.play()
	
func AIBattle(i):
	opEngaged=i
	opIndicator=Falldown.instance()
	opIndicator.animation='yachie'
	opIndicator.position=battleButton[i].rect_position
	opIndicator.position[0]+=55
	add_child(opIndicator)
	
func AISkip():
	CheckStatus()
	
func GameOver():
	var ending=Ending.instance()
	ending.prestige=prestige
	ending.mcStake=mcStake
	ending.mcCash=mcCash
	ending.opStake=opStake
	ending.opCash=opCash
	queue_free()
	get_parent().add_child(ending)

func _on_MeilingBuy_pressed():
	Bid(0)
func _on_MeilingSell_pressed():
	Sell(0)
func _on_SeigaSell_pressed():
	Sell(1)
func _on_JunkoSell_pressed():
	Sell(2)
func _on_SeigaBuy_pressed():
	Bid(1)
func _on_JunkoBuy_pressed():
	Bid(2)


func _on_Skip_pressed():
	if phase<4:
		CheckStatus()


func _on_BuyRange_pressed():
	if phase<4:
		mcCash-=200
		rangeLevel+=1
		$AudioMoney.play()
		CheckStatus()


func _on_BuyHealth_pressed():
	if phase<4:
		mcCash-=200
		healthLevel+=1
		$AudioMoney.play()
		CheckStatus()


func _on_JunkoBattle_pressed():
	Battle(2)
func _on_SeigaBattle_pressed():
	Battle(1)
func _on_MeilingBattle_pressed():
	Battle(0)
