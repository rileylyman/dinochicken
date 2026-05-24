extends Node

enum DinoType {eoraptor, coelophysis, scutellosaurus, Trex}
enum Currency {POOP, DNA, FOOD,}
var curDinoType:DinoType = DinoType.eoraptor

var amountDNA: float = 50.0
var amountPOOP: float = 0.0
var amountFOOD: float = 0.0

func Change_Currency_Amount(c, a: float):
	match c:
		Currency.POOP:
			amountPOOP = snapped(amountPOOP + a, 0.01)
			tmpAmountPOOP = amountPOOP
		Currency.DNA:
			amountDNA = snapped(amountDNA + a, 0.01)
			tmpAmountDNA = amountDNA
		Currency.FOOD:
			amountFOOD = snapped(amountFOOD + a, 0.01)
			tmpAmountFOOD = amountFOOD

func Get_Currency_Amount(c):
	match c:
		Currency.POOP:
			return snapped(amountPOOP, 0.01)
		Currency.DNA:
			return snapped(amountDNA, 0.01)
		Currency.FOOD:
			return snapped(amountFOOD, 0.01)
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

var tmpAmountDNA = amountDNA
var tmpAmountFOOD = amountFOOD
var tmpAmountPOOP = amountPOOP

func _process(delta: float) -> void:
	tmpAmountDNA += speedDNA * delta
	tmpAmountFOOD += speedFOOD * delta
	tmpAmountPOOP += speedPOOP * delta
	
	timer += delta
	if timer >= 0.3:
		amountDNA = tmpAmountDNA
		amountFOOD = tmpAmountFOOD
		amountPOOP = tmpAmountPOOP

		timer = 0.0
