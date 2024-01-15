class_name FloorBuilder extends Node3D

var grassblock = preload("res://wall.tscn")
const blocksize = 2
var blocks = []
const numSpaces = 40
var floorsize = Vector3(8,0,12)
var _floor
var floorTiles = []
var wallTiles = [] 
var decorator = FloorDecorator.new()
var r = RandomNumberGenerator.new()
var scene

func createmap(s):
	scene = s
	_clearblocks()
	var floorfactory = FloorFactory.new()
	_floor = floorfactory.generate(floorsize, numSpaces)
	_buildFromFloor(_floor, floorsize)
	_addLights()

func _buildFromFloor(flr, flrsize):
	for x in flrsize.x:
		for z in flrsize.z:
			var isWall = flr.walls[x][z]
			if isWall:
				var block = _create(Vector3(x * blocksize, 0, z * blocksize))
				blocks.append(block)
				wallTiles.append(Vector3(x,0,z))
			else:
				var tile = _createSteppingStone(Vector3(x * blocksize, 0, z * blocksize))
				blocks.append(tile)
				floorTiles.append(Vector3(x,0,z))

func _clearblocks():
	for block in blocks:
		scene.remove_child(block)
	blocks.clear()
	wallTiles.clear()
	floorTiles.clear()

func _addLights():
	pass 

func _create(pos):
	var instance = grassblock.instantiate()
	instance.position = pos
	scene.add_child(instance)
	return instance

func _createSteppingStone(pos):
	var instance = decorator.randomFloorTileModel()
	instance.position = pos;
	scene.add_child(instance)
	return instance

func getRandomTilePos():
	var index = r.randi_range(0,floorTiles.size()-1)
	var tile = floorTiles[index];
	return tileToPos(tile)

func tileToPos(tile):
	return Vector3(tile.x * blocksize, 0.2, tile.z * blocksize)

func posToTile(pos):
	return Vector3(pos.x / blocksize, 0.2, pos.z / blocksize)

func is_tile_open(tile):
	if tile.x >= floorsize.x || tile.z >= floorsize.z:
		return false
	if tile.z <= 0 || tile.x <= 0:
		return false
	var val = !_floor.walls[tile.x][tile.z]
	return val
