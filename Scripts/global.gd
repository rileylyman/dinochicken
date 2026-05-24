extends Node

enum DinoType {eoraptor, coelophysis, scutellosaurus, Trex}
enum Currency {POOP, DNA, FOOD,}
var curDinoType:DinoType = DinoType.eoraptor

var amountDNA: float = 50.0
var amountPoop: float = 0.0
var amountFood: float = 0.0

func Change_Currency_Amount(c,a:float):
	match c:
		Currency.POOP:
			amountPoop += a
		Currency.DNA:
			amountDNA += a
		Currency.FOOD:
			amountFood += a

func Get_Currency_Amount(c):
	match c:
		Currency.POOP:
			return amountPoop
		Currency.DNA:
			return amountDNA
		Currency.FOOD:
			return amountFood
	
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
