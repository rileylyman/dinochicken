extends Control

var curDinoNum: int = 0 # initial dinosaur number
@export var maxDinoNum: int = 15 # initial maximum dinosaur number
var activeDinos: Array[Dinosaur] = []

# 用于控制拉屎间隔的计时器
var poopTimer: float = 0.0

func _ready():
	Initialize_Dino_Number()
	# 初始化时，先让计时器等于全局的拉屎间隔
	poopTimer = global.poopInterval

func _process(delta: float) -> void:
	if activeDinos.is_empty():
		return
		
	# 倒计时逻辑
	poopTimer -= delta
	if poopTimer <= 0.0:
		poopTimer = global.poopInterval
		
		var randomDino = activeDinos.pick_random()
		if randomDino:
			randomDino.Spawn_Poop(randomDino.dinoType, randomDino.position + Vector2(0, 100), 1)

# Dino Number
func Initialize_Dino_Number():
	%DinoNum.text = "Dino's: %d/%d" % [curDinoNum, maxDinoNum]

func Add_Dino_Number(num: int):
	curDinoNum += num
	%DinoNum.text = "Dino's: %d/%d" % [curDinoNum, maxDinoNum]

# Breed Dinosaur Button
@onready var btAddDino: MarginContainer = $"../MarginContainer/PanelContainer/VBoxContainer/VBoxContainer/UpgradeButton"
func _on_button_pressed() -> void:
	if curDinoNum < maxDinoNum and btAddDino.Can_Click():
		Spawn_Dino(global.curDinoType)
		Add_Dino_Number(1)
		btAddDino.Upgrade()
		# spawn dinosaur
		# based on the type of the dinosaur

const DINO = preload("res://Scenes/dino.tscn")
func Spawn_Dino(type:global.DinoType):
	var newDino = DINO.instantiate()
	%DinoArea.add_child(newDino)
	newDino.Init_Dino(type, %DinoArea)
	var randomTargetPOS = Vector2(
		randf_range(0, %DinoArea.size.x),
		randf_range(0, %DinoArea.size.y)
	)
	var centerPOS = %DinoArea.size / 2.0
	if activeDinos.is_empty():
		
		newDino.position = centerPOS
	else:
		newDino.position = randomTargetPOS
	
	newDino.scale = Vector2.ZERO
	var spawnTween = create_tween()
	spawnTween.tween_property(newDino, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	activeDinos.append(newDino)


### ONLY FOR TEST ###
#func _input(event: InputEvent) -> void:
	#if event is InputEventKey and event.pressed:
		#if event.keycode == KEY_X:
			#Add_Dino_Number(1)
