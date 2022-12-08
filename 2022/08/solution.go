package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	forest := getForest()
	println(countVisible(forest))
	println(getMaxScenicScore(forest))
}

func getForest() [][]int {
	readFile, error := os.Open("input.txt")

	if error != nil {
		fmt.Println(error)
	}

	fileScanner := bufio.NewScanner(readFile)
	fileScanner.Split(bufio.ScanLines)

	forest := [][]int{}

	for fileScanner.Scan() {
		row := []int{}

		for _, numberStr := range strings.Split(fileScanner.Text(), "") {
			number, error := strconv.Atoi(numberStr)

			if error != nil {
				fmt.Println(error)
			}

			row = append(row, number)
		}

		forest = append(forest, row)
	}

	readFile.Close()

	return forest
}

func countVisible(forest [][]int) int {
	count := 0

	for i, row := range forest {
		for j := range row {
			if checkVisibility(-1, 0, forest, i, j) {
				count += 1
			} else if checkVisibility(0, 1, forest, i, j) {
				count += 1
			} else if checkVisibility(1, 0, forest, i, j) {
				count += 1
			} else if checkVisibility(0, -1, forest, i, j) {
				count += 1
			}
		}
	}

	return count
}

func checkVisibility(iMovement int, jMovement int, forest [][]int, i int, j int) bool {
	tree := forest[i][j]
	i += iMovement
	j += jMovement

	for isInForest(i, j, forest) {
		currentTree := forest[i][j]

		if currentTree >= tree {
			return false
		}

		i += iMovement
		j += jMovement
	}

	return true
}

func getMaxScenicScore(forest [][]int) int {
	maxScenicScore := 0

	for i, row := range forest {
		for j := range row {
			scenicScore := 1
			scenicScore *= getVisibleCount(-1, 0, forest, i, j)
			scenicScore *= getVisibleCount(0, 1, forest, i, j)
			scenicScore *= getVisibleCount(1, 0, forest, i, j)
			scenicScore *= getVisibleCount(0, -1, forest, i, j)

			if scenicScore > maxScenicScore {
				maxScenicScore = scenicScore
			}
		}
	}

	return maxScenicScore
}

func getVisibleCount(iMovement int, jMovement int, forest [][]int, i int, j int) int {
	visibleCount := 0
	tree := forest[i][j]
	i += iMovement
	j += jMovement

	for isInForest(i, j, forest) {
		currentTree := forest[i][j]

		if currentTree < tree {
			visibleCount += 1
		} else if currentTree == tree {
			return visibleCount + 1
		}

		i += iMovement
		j += jMovement
	}

	return visibleCount
}

func isInForest(i int, j int, forest [][]int) bool {
	return i >= 0 && j >= 0 && i < len(forest) && j < len(forest[0])
}

// ! Solution A: 1763
// ! Solution B: 671160
