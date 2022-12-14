import { readFileSync } from 'fs';
import { join } from 'path';

export let ROCK = '#';
export let AIR = '.';
export let SAND = '+';
export let REST_SAND = 'o';
export var MIN_X = 0;
export var MIN_Y = 0;

function buildCave(hasFloor: boolean) {
    let lines = readFileSync(join(__dirname, '../input.txt'), 'utf-8').split('\r\n');

    let x = lines.flatMap((line: string) => line.split(' -> ').map((linePart: string) => Number(linePart.split(',')[0]))).sort((a, b) => a - b);
    let y = lines.flatMap((line: string) => line.split(' -> ').map((linePart: string) => Number(linePart.split(',')[1]))).sort((a, b) => a - b);

    let minX = x[0];
    let maxX = x[x.length - 1];
    let minY = 0;
    let maxY = y[y.length - 1];

    if (hasFloor)
        maxY += 2

    MIN_X = minX;
    MIN_Y = minY;

    var cave = Array.from({ length: maxY - minY + 1 }, () => Array<string>(maxX - minX + 1).fill(AIR));

    if (hasFloor)
        for (let i = 0; i < cave[0].length; i++)
            cave[cave.length - 1][i] = ROCK;

    return addRocksToCave(lines, cave);
}

function addRocksToCave(lines: string[], cave: string[][]) {
    lines.forEach((line: string) => {
        let lineSplit = line.split(' -> ');
        for (let i = 0; i < lineSplit.length - 1; i++) {
            let currentLinePart = lineSplit[i];
            let currentX = Number(currentLinePart.split(',')[0]);
            let currentY = Number(currentLinePart.split(',')[1]);

            let nextLinePart = lineSplit[i + 1];
            let nextX = Number(nextLinePart.split(',')[0]);
            let nextY = Number(nextLinePart.split(',')[1]);

            if (currentX == nextX) {
                if (currentY > nextY) currentY = [nextY, nextY = currentY][0];
                for (let j = currentY; j <= nextY; j++)
                    cave[j - MIN_Y][currentX - MIN_X] = ROCK;
            } else {
                if (currentX > nextX) currentX = [nextX, nextX = currentX][0];
                for (let j = currentX; j <= nextX; j++)
                    cave[currentY - MIN_Y][j - MIN_X] = ROCK;
            }
        }
    });

    return cave;
}

function simulateSandProduction(cave: string[][], hasFloor: boolean) {
    var sandStartY = 0;

    var continueWithProduction = true;
    while (continueWithProduction) {
        var sandStartX = 500 - MIN_X;

        if (hasFloor)
            [continueWithProduction, cave] = simulateSandMovementB(cave, sandStartX, sandStartY);
        else
            [continueWithProduction, cave] = simulateSandMovementA(cave, sandStartX, sandStartY);
    }

    return cave;
}

function simulateSandMovementA(cave: string[][], x: number, y: number): [boolean, string[][]] {
    if (x < 0 || y < 0 || y >= cave.length || x >= cave[0].length)
        return [false, cave];

    if (y + 1 >= cave.length || cave[y + 1][x] == AIR) // Down is possible
        return simulateSandMovementA(cave, x, y + 1);

    if (y + 1 >= cave.length || x <= 0 || cave[y + 1][x - 1] == AIR) // Left diagonal is possible
        return simulateSandMovementA(cave, x - 1, y + 1);

    if (y + 1 >= cave.length || x + 1 >= cave[0].length || cave[y + 1][x + 1] == AIR) // Right diagonal is possible
        return simulateSandMovementA(cave, x + 1, y + 1);

    if (cave[y][x] == AIR) {
        cave[y][x] = REST_SAND;
        return [true, cave];
    } else
        return [false, cave];
}

function simulateSandMovementB(cave: string[][], x: number, y: number): [boolean, string[][]] {
    if (y < 0 || y >= cave.length - 1)
        return [false, cave];

    if (y + 1 >= cave.length || cave[y + 1][x] == AIR) // Down is possible
        return simulateSandMovementB(cave, x, y + 1);

    if (y + 1 >= cave.length || x <= 0 || cave[y + 1][x - 1] == AIR) { // Left diagonal is possible
        if (x == 0) {
            for (let i = 0; i < cave.length; i++) {
                cave[i].unshift(i < cave.length - 1 ? AIR : ROCK);
            }
            MIN_X--;
            return simulateSandMovementB(cave, 500 - MIN_X, 0);
        } else
            return simulateSandMovementB(cave, x - 1, y + 1);
    }

    if (y + 1 >= cave.length || x + 1 >= cave[0].length || cave[y + 1][x + 1] == AIR) { // Right diagonal is possible
        if (x + 1 == cave[0].length) {
            for (let i = 0; i < cave.length; i++) {
                cave[i].push(i < cave.length - 1 ? AIR : ROCK);
            }
            return simulateSandMovementB(cave, 500 - MIN_X, 0);
        } else
            return simulateSandMovementB(cave, x + 1, y + 1);
    }

    if (cave[y][x] == AIR) {
        cave[y][x] = REST_SAND;
        return [true, cave];
    } else
        return [false, cave];
}

function calculateSands(cave: string[][]) {
    var sum = 0;

    cave.forEach((line) => {
        line.forEach((tile) => {
            if (tile == REST_SAND)
                sum += 1
        });
    });

    return sum;
}

console.log(calculateSands(simulateSandProduction(buildCave(false), false)))
console.log(calculateSands(simulateSandProduction(buildCave(true), true)))

// ! Solution A: 625
// ! Solution B: 25193
