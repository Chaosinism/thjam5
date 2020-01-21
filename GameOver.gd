extends Control

var prestige=[0,0,0]
var mcStake=[0,0,0]
var opStake=[0,0,0]
var mcCash=0
var opCash=0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Exp1.text=str(mcStake[0])+' * $ '+str(prestige[0])+'00  +  '+str(mcStake[1])+' * $ '+str(prestige[1])+'00 + '+str(mcStake[2])+' * $ '+str(prestige[2])+'00 + $ '+str(mcCash)+' ='
	$Exp2.text=str(opStake[0])+' * $ '+str(prestige[0])+'00  +  '+str(opStake[1])+' * $ '+str(prestige[1])+'00 + '+str(opStake[2])+' * $ '+str(prestige[2])+'00 + $ '+str(opCash)+' ='
	var score1=mcStake[0]*prestige[0]+mcStake[1]*prestige[1]+mcStake[2]*prestige[2]+mcCash/100
	var score2=opStake[0]*prestige[0]+opStake[1]*prestige[1]+opStake[2]*prestige[2]+opCash/100
	$Result1.text='$ '+str(score1)+'00'
	$Result2.text='$ '+str(score2)+'00'
	if score1>score2:
		$Judgement.text='You Win!'
	else:
		$Judgement.text='Yachie Wins!'

func _on_Back_pressed():
	queue_free()
	get_parent().get_node('Main').Reset()
