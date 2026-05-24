extends Node

enum DinoType {eoraptor, coelophysis, scutellosaurus, Trex}
var curDinoType:DinoType = DinoType.eoraptor

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
