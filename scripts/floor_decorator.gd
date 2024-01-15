class_name FloorDecorator extends Node

var rand = RandomNumberGenerator.new()

var stone0 = preload("res://stepping_stone0.tscn")
var stone1 = preload("res://stepping_stone1.tscn")
var stone2 = preload("res://stepping_stone2.tscn")
var stone3 = preload("res://stepping_stone3.tscn")
var stone4 = preload("res://stepping_stone4.tscn")

func _init():
	pass

func getRandomFloorTile():
	pass

func randomFloorTileModel():
	var r = rand.randi_range(0,4)
	if r == 4:
		return stone4.instantiate()
	else:
		return stone3.instantiate()
