extends Node3D

var grassblock = preload("res://grass_cube.tscn")
const blocksize = 2
var blocks = []
const numSpaces = 40
var floor
var floorTiles = []
var wallTiles = []
var decorator = FloorDecorator.new()
var r = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_createmap()

func _buildFromFloor(floor, floorsize):
	for x in floorsize.x:
		for z in floorsize.z:
			var isWall = floor.walls[x][z]
			if isWall:
				var block = _create(Vector3(x * blocksize, 0, z * blocksize))
				blocks.append(block)
				wallTiles.append(Vector3(x,0,z))
			else:
				var tile = _createSteppingStone(Vector3(x * blocksize, 0, z * blocksize))
				blocks.append(tile)
				floorTiles.append(Vector3(x,0,z))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		_clearblocks()
		_createmap()				

func _createmap():
	var floorfactory = FloorFactory.new()
	var floorsize = Vector3(8,0,12)
	floor = floorfactory.generate(floorsize, numSpaces)
	_buildFromFloor(floor, floorsize)

func _clearblocks():
	for block in blocks:
		remove_child(block)
	blocks.clear()	
	wallTiles.clear()
	floorTiles.clear()

func _process(delta):
	pass

func _create(pos):
	var instance = grassblock.instantiate()
	instance.position = pos
	add_child(instance)
	return instance

func _createSteppingStone(pos):
	var instance = decorator.randomFloorTileModel()
	instance.position = pos;
	instance.rotation.y = r.randf()
	add_child(instance)
	return instance
