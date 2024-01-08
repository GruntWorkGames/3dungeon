class_name FloorDecorator extends Node

var stone0 = preload("res://stepping_stone0.tscn")
var stone1 = preload("res://stepping_stone1.tscn")
var stone2 = preload("res://stepping_stone2.tscn")
var stone3 = preload("res://stepping_stone3.tscn")
var r = RandomNumberGenerator.new()

func _init():
	pass

func getRandomFloorTile():
	pass

func randomFloorTileModel():
	return stone3.instantiate()
