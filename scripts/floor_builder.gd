class_name FloorBuilder extends Node3D

var grassblock = preload("res://wall.tscn")
const blocksize = 2
var blocks = []
var wallMesh = {} # map[(x,y,z)] = block
const numSpaces = 40
var floorsize = Vector2i(8, 12)
var floor_ = []
var floorTiles = []
var wallTiles = [] 
var decorator = FloorDecorator.new()
var r = RandomNumberGenerator.new()
var scene

func createmap(s):
	scene = s
	_clearblocks()
	var floorfactory = FloorFactory.new()
	floor_ = floorfactory.generate(floorsize, numSpaces)
	_buildFromFloor(floor_, floorsize)
	_addLights()

func _buildFromFloor(flr, flrsize):
	for x in flrsize.x:
		for y in flrsize.y:
			var isWall = flr[x][y]
			if isWall:
				var blockPos = Vector2i(x * blocksize, y * blocksize)
				var tilePos = Vector2i(x, y)
				var block = _create(blockPos)
				blocks.append(block)
				wallMesh[tilePos] = block;
				wallTiles.append(tilePos)
			else:
				var tile = _createSteppingStone(Vector2i(x * blocksize, y * blocksize))
				blocks.append(tile)
				floorTiles.append(Vector2i(x, y))

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
	instance.position = Vector3(pos.x, 0, pos.y)
	scene.add_child(instance)
	return instance

func _createSteppingStone(pos):
	var instance = decorator.randomFloorTileModel()
	instance.position = Vector3(pos.x, 0, pos.y);
	scene.add_child(instance)
	return instance

func getRandomTilePos():
	var index = r.randi_range(0, floorTiles.size()-1)
	var tile = floorTiles[index];
	return tileToPos(tile)

func tileToPos(tile):
	return Vector3(tile.x * blocksize, 0, tile.y * blocksize)

func posToTile(pos):
	return Vector2i(pos.x / blocksize, pos.z / blocksize)

func is_tile_open(tile):
	if tile.x >= floorsize.x || tile.y >= floorsize.y:
		return false
	if tile.y <= 0 || tile.x <= 0:
		return false
	var val = !floor_[tile.x][tile.y]
	return val
