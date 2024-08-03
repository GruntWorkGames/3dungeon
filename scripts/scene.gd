extends Node3D

var enemyPrefab = preload("res://enemy1.tscn")
var floor_builder = FloorBuilder.new()
var shouldContinue = false
var lastDirection
var enemies = []
var astar = AStarGrid2D.new()
var curEnemyIndex = 0
var playerCanMove = true
var translucentBlocks = [] # list of . the  is the key meshTiles[]

func _ready():
	floor_builder.createmap(self)
	%player.position = floor_builder.getRandomTilePos()
	_placeEnemy()
	_createAStar()

func _createAStar():
	astar.region = Rect2i(0, 0, 8, 12)
	astar.cell_size = Vector2i(1, 1)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	for wall in floor_builder.wallTiles:
		astar.set_point_solid(Vector2i(wall.x, wall.y), true)

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
	var path = astar.get_point_path(enemyTile, playerTile)
	
	#var floor = floor_builder.floor.duplicate()
	#_addOtherEnemiesToFloor(floor, enemy)
	#var path = aStar.find_path(enemyTile, playerTile, floor_builder.floor)
	#var firstEnemyInPath = _first_enemy_in_path(path)
	#if firstEnemyInPath != null:
		#print("there is another enemy in the way!\nattempting to find a path around the enemy")
		#var pathAroundEnemies = aStar.find_path(enemyTile, playerTile, floor)
		
	if(path.size() <= 0):
		print(path.size())
		
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

func _first_enemy_in_path(path: Array):
	for tile in path:
		for enemy in enemies:
			if tile == floor_builder.posToTile(enemy.position):
				return {"tile":tile, "enemy": enemy}
	return null
	
func _addOtherEnemiesToFloor(floor_, other):
	for enemy in enemies:
		if enemy != other:
			var enemyTile = floor_builder.posToTile(enemy.position)
			floor_[enemyTile.x][enemyTile.z] = true
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
		if fromTile.y == toTile.y:
			return "error - same tile"
		elif fromTile.y > toTile.y:
			return "up"
		else: return "down"
	elif fromTile.y == toTile.y:
		if fromTile.x == toTile.x:
			return "error"
		elif fromTile.x > toTile.x:
			return "left"
		else: return "right"
	return "error - ??"

func _placeEnemy():
	for x in 3:
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
	_hide_cells_below_player();
	_moveEnemies()

func _checkEscape():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _entity_can_move(entity, dir):
	var tile = floor_builder.posToTile(entity.position)
	match dir:
		"up":
			tile.y = tile.y - 1
		"down":
			tile.y = tile.y + 1
		"left":
			tile.x = tile.x - 1
		"right":
			tile.x = tile.x + 1
	return floor_builder.is_tile_open(tile) and !is_tile_blocked_by_entity(tile)

func is_tile_blocked_by_entity(tile):
	for enemy in enemies:
		var enemyTile = floor_builder.posToTile(enemy.position)
		if tile.x == enemyTile.x && tile.y == enemyTile.y:
			print("next tile is an enemy")
			return true
	return false

func _hide_cells_below_player():
	# clear all blocks
	for block in translucentBlocks:
		block.set_transparency(0.0)
		
	# get the tile below the player
	var tile1 = floor_builder.posToTile(%player.position)
	tile1.y = tile1.y + 1
	
	# if the tile below the player is blocked, hide it and the left and right
	if !floor_builder.is_tile_open(tile1):
		# get left and right tiles
		var r_tile = (tile1)
		r_tile.x = r_tile.x + 1
		var l_tile = (tile1)
		l_tile.x = l_tile.x - 1
		var tilez = [l_tile, tile1, r_tile]
		
		#for each tile, check if its a wall and then hide it
		for tile in tilez:
			if tile.y <= 4 && !floor_builder.is_tile_open(tile) && floor_builder.wallMesh.has(tile):
				var block = floor_builder.wallMesh[tile]
				if(block != null):
					block.set_transparency(0.6)
					translucentBlocks.append(block)
					pass
		
	

