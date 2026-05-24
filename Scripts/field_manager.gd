extends Control

var curDinoNum: int = 0 # initial dinosaur number
@export var maxDinoNum: int = 15 # initial maximum dinosaur number
var activeDinos: Array[Dinosaur] = []

func _ready():
	Initialize_Dino_Number()

# Dino Number
func Initialize_Dino_Number():
	%DinoNum.text = "Dino's: %d/%d" % [curDinoNum, maxDinoNum]

func Add_Dino_Number(num: int):
	curDinoNum += num
	%DinoNum.text = "Dino's: %d/%d" % [curDinoNum, maxDinoNum]

func _on_button_pressed() -> void:
	if curDinoNum < maxDinoNum:
		Spawn_Dino(global.curDinoType)
		Add_Dino_Number(1)
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
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_X:
			Add_Dino_Number(1)
