class_name FloorDecorator extends Node

var rand = RandomNumberGenerator.new()
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
