class_name AStar extends Node

func find_path(start: Vector3, goal: Vector3, grid: Array) -> Array:
	var openSet: Array = []
	var closedSet: Array = []

	var startNode = AStar_Node.new(start)
	var goalNode = AStar_Node.new(goal)

	openSet.append(startNode)

	while openSet.size() > 0:
		var currentNode = get_lowest_fscore_node(openSet)

		if currentNode.pos == goalNode.pos:
			return reconstruct_path(currentNode)

		openSet.erase(currentNode)
		closedSet.append(currentNode)

		var neighbors = get_neighbors(currentNode, grid)

		for neighbor in neighbors:
			if neighbor in closedSet:
				continue

			var tentativeGScore = currentNode.gScore + get_distance(currentNode, neighbor)

			if neighbor not in openSet:
				openSet.append(neighbor)
			elif tentativeGScore >= neighbor.gScore:
				continue

			neighbor.parentNode = currentNode
			neighbor.gScore = tentativeGScore
			neighbor.hScore = get_distance(neighbor, goalNode)
			neighbor.fScore = neighbor.gScore + neighbor.hScore

	return []  # No path found

func get_lowest_fscore_node(nodes: Array) -> AStar_Node:
	var lowestNode = nodes[0]

	for node in nodes:
		if node.fScore < lowestNode.fScore:
			lowestNode = node

	return lowestNode

func get_neighbors(node: AStar_Node, grid: Array) -> Array:
	var neighbors: Array = []
	var directions = [Vector3(1, 0, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, -1)]

	for direction in directions:
		var neighborPosition = node.pos + direction

		if is_valid_position(neighborPosition, grid):
			var neighborNode = AStar_Node.new(neighborPosition, node)
			neighbors.append(neighborNode)

	return neighbors

func is_valid_position(position: Vector3, grid: Array) -> bool:
	var gridSizeX = grid.size()
	var gridSizeY = grid[0].size()
	var wall = true
	return position.x >= 0 and position.x < gridSizeX and position.z >= 0 and position.z < gridSizeY and grid[int(position.x)][int(position.z)] != wall
func get_distance(nodeA: AStar_Node, nodeB: AStar_Node) -> float:
	return nodeA.pos.distance_to(nodeB.pos)

func reconstruct_path(node: AStar_Node) -> Array:
	var path: Array = []
	var currentNode = node

	while currentNode.parentNode != null:
		path.append(currentNode.pos)
		currentNode = currentNode.parentNode

	path.append(currentNode.pos)
	path.reverse()

	return path

