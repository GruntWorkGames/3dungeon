extends Node3D

var enemyPrefab = preload("res://enemy1.tscn")
var floor_builder = FloorBuilder.new()
var shouldContinue = false
var lastDirection
var enemies = []
var aStar = AStar.new()
var curEnemyIndex = 0
var playerCanMove = true

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
		_move_player(%player, "left")
		shouldContinue = true
		return
	else: if event.is_action_pressed("right"):
		_move_player(%player, "right")
		shouldContinue = true
		return
	else: if event.is_action_pressed("up"):
		_move_player(%player, "up")
		shouldContinue = true
		return
	else: if event.is_action_pressed("down"):
		_move_player(%player, "down")
		shouldContinue = true
		return

func _moveEnemies():
	var enemy = enemies[curEnemyIndex]
	_moveEnemy(enemy)

func _moveEnemy(enemy):
	var enemyTile = floor_builder.posToTile(enemy.position)
	var playerTile = floor_builder.posToTile(%player.position)
	var floor = floor_builder.floor
	#_addOtherEnemiesToFloor(floor, enemy)
	var path = aStar.find_path(enemyTile, playerTile, floor)
	if(path.size() <= 2):
		_enemyFinished()
		return
	var nextTile = path[1]
	var dir = _directionFromTo(enemyTile, nextTile)
	enemy.face_dir(dir)
	if _entity_can_move(enemy, dir):
		enemy.move(dir, _enemyFinished)
	else:
		_enemyFinished()

func _addOtherEnemiesToFloor(floor, other):
	for enemy in enemies:
		if enemy != other:
			var enemyTile = floor_builder.posToTile(enemy.position)
			floor[enemyTile.x][enemyTile.z] = true
		else:
			print("other enemy")

func _enemyFinished():
	if curEnemyIndex < enemies.size()-1:
		curEnemyIndex += 1
		_moveEnemies()
	else:
		curEnemyIndex = 0
		playerCanMove = true

func _directionFromTo(fromTile, toTile):
	if fromTile.x == toTile.x:
		if fromTile.z == toTile.z:
			return "error - same tile"
		elif fromTile.z > toTile.z:
			return "up"
		else: return "down"
	elif fromTile.z == toTile.z:
		if fromTile.x == toTile.x:
			return "error"
		elif fromTile.x > toTile.x:
			return "left"
		else: return "right"
	return "error - ??"

func _placeEnemy():
	for x in 5:
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
	%player.face_dir(direction)
	if playerCanMove:
		_move_player(%player, direction)

func _move_player(entity, direction):
	if _entity_can_move(entity,direction):
		lastDirection = direction
		playerCanMove = false
		entity.move(direction, _playerFinishedMove)
	else:
		_playerFinishedMove()

func _playerFinishedMove():
	_moveEnemies()

func _checkEscape():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _entity_can_move(entity, dir):
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
	return floor_builder.is_tile_open(tile) and !is_tile_blocked_by_entity(tile)

func is_tile_blocked_by_entity(tile):
	for enemy in enemies:
		var enemyTile = floor_builder.posToTile(enemy.position)
		if tile.x == enemyTile.x && tile.z == enemyTile.z:
			print("next tile is an enemy")
			return true
	return false
