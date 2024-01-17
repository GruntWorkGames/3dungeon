extends Node3D

var enemyPrefab = preload("res://enemy1.tscn")
var floor_builder = FloorBuilder.new()
var shouldContinue = false
var lastDirection
var enemies = []
var aStar = AStar.new()
var nextEnemy = null

func _ready():
	floor_builder.createmap(self)
	%player.position = floor_builder.getRandomTilePos()
	_placeEnemy()

func _input(event):
	_checkEscape()
	_checkSpace()
	
	if !event is InputEventKey:
		return
		
	if event.is_released():
		shouldContinue = false
	
	if event.is_action_pressed("left"):
		_move_entity(%player, "left")
		shouldContinue = true
		return
	else: if event.is_action_pressed("right"):
		_move_entity(%player, "right")
		shouldContinue = true
		return
	else: if event.is_action_pressed("up"):
		_move_entity(%player, "up")
		shouldContinue = true
		return
	else: if event.is_action_pressed("down"):
		_move_entity(%player, "down")
		shouldContinue = true
		return

func _moveEnemies():
	for enemy in enemies:
		var enemyTile = floor_builder.posToTile(enemy.position)
		var playerTile = floor_builder.posToTile(%player.position)
		var path = aStar.find_path(enemyTile, playerTile, floor_builder.floor)
		var nextTile = path[1]
		var dir = _directionFromTo(enemyTile, nextTile)
		enemy.face_dir(dir)
		enemy.move(dir, enemyFinished)

func enemyFinished():
	pass

func _directionFromTo(fromTile, toTile):
	if fromTile.x == toTile.x:
		if fromTile.z == toTile.z:
			return "error1"
		elif fromTile.z > toTile.z:
			return "up"
		else: return "down"
	elif fromTile.z == toTile.z:
		if fromTile.x == toTile.x:
			return "error"
		elif fromTile.x > toTile.x:
			return "left"
		else: return "right"
	return "error2"

func _placeEnemy():
	var enemy = enemyPrefab.instantiate()
	enemies.append(enemy)
	enemy.position = floor_builder.getRandomTilePos()
	add_child(enemy)

func _checkSpace():
	if Input.is_action_just_pressed("newLevel"):
		floor_builder.createmap(self)
		%player.position = floor_builder.getRandomTilePos()
		
		for enemy in enemies:
			remove_child(enemy)
		enemies.clear()
		_placeEnemy()

func swipe_event(direction):
	_move_entity(%player, direction)

func _move_entity(entity, direction):
	entity.face_dir(direction)
	if _can_move(entity,direction):
		lastDirection = direction
		entity.move(direction,_playerFinishedMove)

func _playerFinishedMove():
	if shouldContinue:
		_move_entity(%player,lastDirection)
	_moveEnemies()

func _checkEscape():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _can_move(entity, dir):
	var tile = floor_builder.posToTile(entity.position)
	match dir:
		"up":
			tile.z = tile.z - 1
		"down":
			tile.z = tile.z + 1
		"left":
			tile.x = tile.x - 1
		"right":
			tile.x = tile.x + 1
	return floor_builder.is_tile_open(tile)
