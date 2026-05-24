extends Node

enum DinoType {eoraptor, coelophysis, scutellosaurus, Trex}
enum Currency {POOP, DNA, FOOD,}
var curDinoType:DinoType = DinoType.eoraptor

var amountDNA: float = 0.0
var amountPoop: float = 0.0
var amountFood: float = 0.0

func Change_Currency_Amount(c, a: float):
	match c:
		Currency.POOP:
			amountPoop = snapped(amountPoop + a, 0.01)
		Currency.DNA:
			amountDNA = snapped(amountDNA + a, 0.01)
		Currency.FOOD:
			amountFood = snapped(amountFood + a, 0.01)

func Get_Currency_Amount(c):
	match c:
		Currency.POOP:
			return snapped(amountPoop, 0.01)
		Currency.DNA:
			return snapped(amountDNA, 0.01)
		Currency.FOOD:
			return snapped(amountFood, 0.01)
	return 0.0
	
func Get_Dino_Name_String(type:DinoType):
	match type:
		DinoType.eoraptor:
			return "eoraptor"
		DinoType.coelophysis:
			return "coelophysis"
		DinoType.scutellosaurus:
			return "scutellosaurus"
		DinoType.Trex:
			return "Trex"
			
# incremental test		
var timer: float = 0.0
var speedDNA = 0.5
var speedFOOD = 0.4
var speedPOOP = 0.3

var tmpAmountDNA = 0.0
var tmpAmountFOOD = 0.0
var tmpAmountPOOP = 0.0

func _process(delta: float) -> void:
	tmpAmountDNA += speedDNA * delta
	tmpAmountFOOD += speedFOOD * delta
	tmpAmountPOOP += speedPOOP * delta
	
	timer += delta
	if timer >= 0.3:
		amountDNA = tmpAmountDNA
		amountFood = tmpAmountFOOD
		amountPoop = tmpAmountPOOP
		timer = 0.0 # 计时器清零，等待下一个 0.3 秒
