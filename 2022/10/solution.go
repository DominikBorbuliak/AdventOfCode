package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Instruction struct {
	CyclesToFinish int
	Value          int
}

func main() {
	registerValues := getRegisterValues(getInstructions())
	println(getSumDuringInterestingCycles(registerValues))
	printCRTLine(getCRTLine(registerValues))
}

func getInstructions() []Instruction {
	readFile, error := os.Open("input.txt")

	if error != nil {
		fmt.Println(error)
	}

	fileScanner := bufio.NewScanner(readFile)
	fileScanner.Split(bufio.ScanLines)

	instructions := []Instruction{}

	for fileScanner.Scan() {
		lineSplit := strings.Split(fileScanner.Text(), " ")

		if lineSplit[0] == "noop" {
			instructions = append(instructions, Instruction{CyclesToFinish: 1, Value: 0})
		} else {
			value, _ := strconv.Atoi(lineSplit[1])
			instructions = append(instructions, Instruction{CyclesToFinish: 2, Value: value})
		}
	}

	return instructions
}

func getRegisterValues(instructions []Instruction) []int {
	registerValue := 1
	registerValues := []int{}

	for _, instruction := range instructions {
		for i := 0; i < instruction.CyclesToFinish; i++ {
			registerValues = append(registerValues, registerValue)
		}

		registerValue += instruction.Value
	}

	return registerValues
}

func isInterestingCycle(n int) bool {
	if n == 20 {
		return true
	}

	return (n-20)%40 == 0
}

func getSumDuringInterestingCycles(registerValues []int) int {
	sum := 0

	for i, registerValue := range registerValues {
		if isInterestingCycle(i + 1) {
			sum += registerValue * (i + 1)
		}
	}

	return sum
}

func getCRTLine(registerValues []int) string {
	crtLine := ""

	for i, registerValue := range registerValues {
		if isLitPixel(i+1, registerValue) {
			crtLine += "#"
		} else {
			crtLine += "."
		}
	}

	return crtLine
}

func printCRTLine(line string) {
	for i, char := range line {
		print(string(char))

		if (i+1)%40 == 0 {
			println()
		}
	}
}

func isLitPixel(cycle int, spriteStart int) bool {
	return (cycle%40) >= spriteStart && (cycle%40) <= spriteStart+2
}

// ! Solution A: 11720
// ! Solution B: ERCREPCJ
