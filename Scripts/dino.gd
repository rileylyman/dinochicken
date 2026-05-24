extends Node2D
class_name Dinosaur

var dinoType:global.DinoType

var speed:float
var speedMin = 50.0
var speedMax = 100.0
var moveDirection = Vector2.ZERO
var fieldBounds:Control

func Init_Dino(type:global.DinoType, boundsControl:Control):
	dinoType = type
	fieldBounds = boundsControl
	speed = randf_range(speedMin, speedMax)
	Play_Dino_Animation("run")
	Set_Random_Direction()

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func Play_Dino_Animation(stateName:String):
	var dinoName = global.Get_Dino_Name_String(dinoType)
	sprite.play(dinoName + "_" + stateName)

func Set_Random_Direction():
	var randomAngle = randf_range(0, TAU)
	moveDirection = Vector2.RIGHT.rotated(randomAngle).normalized()

func Check_Boundary_Collision():
	# left right check
	if position.x <= 0:
		position.x = 0
		moveDirection.x = abs(moveDirection.x) # 强制向右
	elif position.x >= fieldBounds.size.x:
		position.x = fieldBounds.size.x
		moveDirection.x = -abs(moveDirection.x) # 强制向左
		
	# up down check
	if position.y <= 0:
		position.y = 0
		moveDirection.y = abs(moveDirection.y) # 强制向下
	elif position.y >= fieldBounds.size.y:
		position.y = fieldBounds.size.y
		moveDirection.y = -abs(moveDirection.y) # 强制向上

func Handle_Sprite_Flip():
	if moveDirection.x < -0.01:
		sprite.flip_h = false
	elif moveDirection.x > 0.01:
		sprite.flip_h = true

func _process(delta: float) -> void:
	# check if it's spawning
	if scale.x < 0.9: 
		return

	position += moveDirection * speed * delta
	Check_Boundary_Collision()
	Handle_Sprite_Flip()
