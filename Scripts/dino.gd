extends Node2D
class_name Dinosaur

var dinoType:global.DinoType

var speed:float
var speedMin = 50.0
var speedMax = 100.0
var moveDirection = Vector2.ZERO
var fieldBounds:Control

enum dinoState{run, idle, poop}
var curState
var stateTimer: float = 0.0
var runMin: float = 3.0
var runMax: float = 6.0
var idleMin: float = 1.5
var idleMax: float = 3.5

# sprite size
var halfW: float = 0.0
var halfH: float = 0.0

@onready var sprite: AnimatedSprite2D = $dinoAni
# Added a Marker2D node reference to precisely position the poop without offset math
@onready var poop_spawn_point: Marker2D = $PoopSpawnPoint

func Init_Dino(type:global.DinoType, boundsControl:Control):
	dinoType = type
	fieldBounds = boundsControl
	speed = randf_range(speedMin, speedMax)
	
	if sprite == null:
		sprite = $dinoAni
		
	# FIXED: Always update size and boundaries BEFORE switching states. 
	# Otherwise, if it starts in "poop" state, the spawn point will be stuck at (0,0) on frame 1.
	Update_Dino_Size()
	
	# area limit
	if position == Vector2.ZERO or position.x < halfW or position.x > fieldBounds.size.x - halfW or position.y < halfH or position.y > fieldBounds.size.y - halfH:
		position.x = randf_range(halfW, fieldBounds.size.x - halfW)
		position.y = randf_range(halfH, fieldBounds.size.y - halfH)
	else:
		position.x = clampf(position.x, halfW, fieldBounds.size.x - halfW)
		position.y = clampf(position.y, halfH, fieldBounds.size.y - halfH)

	if randf() > 0.3:
		Switch_To_State(dinoState.run)
	else:
		Switch_To_State(dinoState.idle)

func _ready() -> void:
	Update_Dino_Size()

func Switch_To_State(state):
	curState = state
	match curState:
		dinoState.run:
			Play_Dino_Animation("run")
			Set_Random_Direction()
			stateTimer = randf_range(runMin, runMax)
		dinoState.idle:
			Play_Dino_Animation("idle")
			moveDirection = Vector2.ZERO
			stateTimer = randf_range(idleMin, idleMax)
		dinoState.poop:
			# FIXED: Changed from "idle" to "poop" animation. 
			# (If your sprite frames use a different name like "idle", change this string back)
			Play_Dino_Animation("idle")
			moveDirection = Vector2.ZERO
			stateTimer = 2.0
			
			# FIXED: Force position update to complete execution before poop spawns
			# This prevents the dinosaur from sliding while poop is instantiated
			force_update_transform()
			
			# need some change
			if poop_spawn_point:
				Spawn_Poop(dinoType, poop_spawn_point.global_position, 2)
			else:
				Spawn_Poop(dinoType, global_position, 2)
			
	Update_Dino_Size()

func Play_Dino_Animation(stateName:String):
	var dinoName = global.Get_Dino_Name_String(dinoType)
	if sprite == null:
		sprite = $dinoAni
	sprite.play(dinoName + "_" + stateName)

func Set_Random_Direction():
	var randomAngle = randf_range(0, TAU)
	moveDirection = Vector2.RIGHT.rotated(randomAngle).normalized()
	Handle_Sprite_Flip()

#func Check_Boundary_Collision():
	## left right check
	#if position.x <= 0:
		#position.x = 0
		#moveDirection.x = abs(moveDirection.x) # 强制向右
	#elif position.x >= fieldBounds.size.x:
		#position.x = fieldBounds.size.x
		#moveDirection.x = -abs(moveDirection.x) # 强制向左
		#
	## up down check
	#if position.y <= 0:
		#position.y = 0
		#moveDirection.y = abs(moveDirection.y) # 强制向下
	#elif position.y >= fieldBounds.size.y:
		#position.y = fieldBounds.size.y
		#moveDirection.y = -abs(moveDirection.y) # 强制向上

func Update_Dino_Size():
	if sprite == null:
		sprite = $dinoAni
	var current_anim = sprite.animation
	var texture = sprite.get_sprite_frames().get_frame_texture(current_anim, 0)
	if texture:
		var textureSize = texture.get_size()
		halfW = (textureSize.x * abs(scale.x)) / 2.0
		halfH = (textureSize.y * abs(scale.y)) / 2.0

func Check_Boundary_Collision():
	if position.x <= halfW:
		position.x = halfW
		moveDirection.x = abs(moveDirection.x)
		Handle_Sprite_Flip()
	elif position.x >= fieldBounds.size.x - halfW:
		position.x = fieldBounds.size.x - halfW
		moveDirection.x = -abs(moveDirection.x)
		Handle_Sprite_Flip()
		
	# up down check
	if position.y <= halfH:
		position.y = halfH
		moveDirection.y = abs(moveDirection.y)
	elif position.y >= fieldBounds.size.y - halfH:
		position.y = fieldBounds.size.y - halfH
		moveDirection.y = -abs(moveDirection.y)

func Handle_Sprite_Flip():
	if sprite == null:
		sprite = $dinoAni
	if moveDirection.x < -0.01:
		sprite.flip_h = false
		if poop_spawn_point:
			poop_spawn_point.position.x = abs(poop_spawn_point.position.x)
	elif moveDirection.x > 0.01:
		sprite.flip_h = true
		if poop_spawn_point:
			poop_spawn_point.position.x = -abs(poop_spawn_point.position.x)

func Order_To_Poop() -> bool:
	if curState == dinoState.poop or scale.x < 0.9:
		return false
	Switch_To_State(dinoState.poop)
	return true

func _process(delta: float) -> void:
	# check if it's spawning
	if scale.x < 0.9: 
		Update_Dino_Size()
		Check_Boundary_Collision()
		Handle_Sprite_Flip()
		return
		
	stateTimer -= delta
	if stateTimer <= 0.0:
		if curState == dinoState.poop:
			Switch_To_State(dinoState.run)
		elif curState == dinoState.run:
			Switch_To_State(dinoState.idle)
		else:
			Switch_To_State(dinoState.run)

	# CRITICAL FIX: If the state is poop, countdown the timer but DO NOT run any position updates.
	# This completely isolates the node's transform from leaking velocities.
	if curState == dinoState.poop:
		moveDirection = Vector2.ZERO
		return # Hard stop right here, bypass the rest of movement logic

	match curState:
		dinoState.run:
			position += moveDirection * speed * delta
			Check_Boundary_Collision()
			Handle_Sprite_Flip()
		dinoState.idle:
			moveDirection = Vector2.ZERO

var POOP = load("res://Scenes/poop.tscn")
# input customized position and scale for each dino
# and have to consider flip
# i don't want to do that
# so i leave these here for now
func Spawn_Poop(type, poopPOS: Vector2, poopScale:int):
	if POOP == null:
		return
		
	var newPoop = POOP.instantiate()
	
	newPoop.scale = Vector2(abs(scale.x) * poopScale, abs(scale.y) * poopScale)
	
	var container = get_parent().find_child("DinoPoop")
	if container:
		container.add_child(newPoop)
	else:
		get_parent().add_child(newPoop)
		
	newPoop.global_position = poopPOS
	newPoop.force_update_transform()
	
	if newPoop.has_method("play"):
		newPoop.play("pooping")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_X:
			Order_To_Poop()
