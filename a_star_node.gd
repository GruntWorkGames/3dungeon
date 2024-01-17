class_name AStar_Node

var pos: Vector3
var gScore: float
var hScore: float
var fScore: float
var parentNode: AStar_Node

func _init(pos: Vector3, parentNode: AStar_Node = null):
	self.pos = pos
	self.gScore = 0
	self.hScore = 0
	self.fScore = 0
	self.parentNode = parentNode
