class_name Econ
extends Node

class DinoStats:
    var level: int = 0
    var yield_modifier: float = 1.0
    var freq_modifier: float = 1.0
    var aggro_modifier: float = 0.0
    var hunger_modifier: float = 1.0

var current_dino := DinoStats.new()

var dna: float = 0.0
var poop: float = 0.0
var food: float = 0.0

var lab_vials: Array[float] = [0.0]

var field_dinos: Array[float] = [0.0]
var field_hunger := 0.0

var farm_plants: Array[float] = [0.0]
var farm_research_level := 0.0
var farm_research_exp := 0.0
var farm_research_rate := 0.1

func _process(delta: float) -> void:
    _tick_lab(delta)
    _tick_field(delta)
    _tick_farm(delta)

func _tick_farm(delta: float) -> void:
    for v in farm_plants:
        v += delta
        if v > 1.0 / upgrade_value("farm_freq"):
            v = 0.0
            food += upgrade_value("farm_yield")

    farm_research_exp += farm_research_rate * delta
    if farm_research_exp >= 1.0:
        farm_research_level += 1.0
        farm_research_exp -= 1.0

func _tick_field(delta: float) -> void:
    for v in field_dinos:
        v += delta
        if v > 1.0 / upgrade_value("field_freq", current_dino.level) * current_dino.freq_modifier:
            v = 0.0
            poop += upgrade_value("field_yield", current_dino.level) * current_dino.yield_modifier

    field_hunger = clamp(field_hunger + upgrade_value("field_hunger_rate") * current_dino.hunger_modifier * delta, 0.0, 1.0)

func _tick_lab(delta: float) -> void:
    for v in lab_vials:
        v += delta
        if v > 1.0 / lab_freq:
            v = 0.0
            dna += lab_yield

var upgrade_level: Dictionary[String, int] = {
    "lab_count": 0,
    "lab_yield": 0,
    "lab_freq": 0,
    "field_count": 0,
    "farm_count": 0,
    "farm_freq": 0
}

func upgrade_value(u: String, level: int = -1) -> float:
    level = level if level != -1 else upgrade_level[u]
    match u:
        "lab_count":
            return level + 1
        "lab_yield":
            return pow(level, 1.25) + 1
        "lab_freq":
            return pow(level, 1.25) + 1
        "field_count":
            return level + 1
        "field_yield":
            return pow(level, 1.25) + 1
        "field_freq":
            return pow(level, 1.25) + 1
        "farm_count":
            return level + 1
        "farm_freq":
            return pow(level, 1.25) + 1
        _:
            assert(false)
            return 0.0

func upgrade_cost(u: String, level: int = -1) -> float:
    level = level if level != -1 else upgrade_level[u]
    match u:
        "lab_count":
            return 10.0 * pow(1.1, level)
        "lab_yield":
            return 10.0 * pow(1.1, level)
        "lab_freq":
            return 10.0 * pow(1.1, level)
        "field_count":
            return 10.0 * pow(1.1, level)
        "farm_count":
            return 10.0 * pow(1.1, level)
        "farm_freq":
            return 10.0 * pow(1.1, level)
        _:
            assert(false)
            return 0.0
