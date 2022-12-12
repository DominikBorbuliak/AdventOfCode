import std/deques

proc getGraph(): tuple[graph: seq[seq[int]], start: tuple[i: int, j: int], finish: tuple[i: int, j: int]] =
    var graph: seq[seq[int]]
    var start, finish: tuple[i: int, j: int] = (-1, -1)
    var x, y = 0

    for line in lines "input.txt":
        var row: seq[int]
        y = 0
        for character in line:
            if character == 'S':
                start = (x, y)
                row.add(ord('a'))
            elif character == 'E':
                finish = (x, y)
                row.add(ord('z'))
            else:
                row.add(ord(character))

            y += 1

        x += 1
        graph.add(row)

    return (graph, start, finish)

proc getVisited(graph: seq[seq[int]]): seq[seq[bool]] =
    var visited: seq[seq[bool]]

    for gRow in graph:
        var row: seq[bool]
        for _ in gRow:
            row.add(false)
        visited.add(row)

    return visited

proc getDistance(graph: seq[seq[int]]): seq[seq[int]] =
    var distance: seq[seq[int]]

    for gRow in graph:
        var row: seq[int]
        for _ in gRow:
            row.add(high(int))
        distance.add(row)

    return distance

proc getPossiblePaths(graph: seq[seq[int]], i: int, j: int): seq[tuple[i: int, j: int]] =
    var directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    var paths: seq[tuple[i: int, j: int]]
    var currentElevation = graph[i][j]

    for (movI, movJ) in directions:
        var newI = i + movI
        var newJ = j + movJ

        if newI < 0 or newJ < 0 or newI >= len(graph) or newJ >= len(graph[0]):
            continue

        if currentElevation + 1 >= graph[newI][newJ]:
            paths.add((newI, newJ))

    return paths

proc shortestPath(graph: seq[seq[int]], start: tuple[i: int, j: int], finish: tuple[i: int, j: int]): int =
    var queue = [start].toDeque
    var visited = getVisited(graph)
    var distance = getDistance(graph)

    distance[start[0]][start[1]] = 0
    visited[start[0]][start[1]] = true

    while len(queue) != 0:
        var (uI, uJ) = queue.popFirst()

        for (vI, vJ) in getPossiblePaths(graph, uI, uJ):
            if not visited[vI][vJ]:
                visited[vI][vJ] = true
                distance[vI][vJ] = distance[uI][uJ] + 1
                queue.addLast((vI, vJ))

                if (vI, vJ) == finish:
                    return distance[vI][vJ]

    return high(int)

proc getAllPossibleStarts(graph: seq[seq[int]]): seq[tuple[i: int, j: int]] =
    var starts: seq[tuple[i: int, j: int]]

    for i in 0..<len(graph):
        for j in 0..<len(graph[i]):
            if graph[i][j] == ord('a'):
                starts.add((i, j))

    return starts

proc getBestStartShortestPath(starts: seq[tuple[i: int, j: int]], graph: seq[seq[int]], finish: tuple[i: int, j: int]): int =
    var min = high(int)

    for start in starts:
        var path = shortestPath(graph, start, finish)
        min = min(min, path)

    return min

var (graph, start, finish) = getGraph()
echo shortestPath(graph, start, finish)
echo getBestStartShortestPath(getAllPossibleStarts(graph), graph, finish)

# ! Solution A: 472
# ! Solution B: 465
