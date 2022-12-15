import { readFileSync } from 'fs';
import { join } from 'path';

function readLines() {
    return readFileSync(join(__dirname, '../input.txt'), 'utf-8').split('\r\n');
}

const sensors = readLines().map((line) => {
    var lineSplit = line.split(", ")
        .flatMap((linePart) => linePart.split(": "))
        .flatMap((linePart) => linePart.split(" "));

    var sensorX = Number(lineSplit[2].split("=")[1]);
    var sensorY = Number(lineSplit[3].split("=")[1]);
    var beaconX = Number(lineSplit[8].split("=")[1]);
    var beaconY = Number(lineSplit[9].split("=")[1]);

    return {
        x: sensorX,
        y: sensorY,
        bX: beaconX,
        bY: beaconY,
        r: Math.abs(beaconX - sensorX) + Math.abs(beaconY - sensorY)
    };
});

// Code below this is heavily inspired by: https://github.com/Namoop/sf/blob/master/aoc2022/day15.ts
//I could not figure out smart way... :(

const discovery = (row: number, minX: number, maxX: number, isSecond: boolean) => {
    var rowRangesCovered: Array<[number, number]> = [];
    var rowBeacons = new Set<number>();

    sensors.forEach((sensor) => {
        var rowDist = Math.abs(sensor.y - row);

        var possibleMovements = sensor.r - rowDist;
        if (possibleMovements <= 0)
            return;

        var rangeStart = sensor.x - possibleMovements;
        var rangeEnd = sensor.x + possibleMovements + 1;

        rangeStart = Math.max(rangeStart, minX);
        rangeEnd = Math.min(rangeEnd, maxX);

        rowRangesCovered.push([rangeStart, rangeEnd]);

        if (sensor.bY == row && sensor.bX >= rangeStart && sensor.bX <= rangeEnd)
            rowBeacons.add(sensor.bX);
    });

    let covered = 0;
    let relLower = -Infinity;
    let relUpper = -Infinity;

    rowRangesCovered.sort((a, b) => a[0] - b[0]);
    var maybeFree: number[][] = [];

    for (let range of rowRangesCovered) {
        let [lower, upper] = range;

        if (lower <= relUpper) {
            if (upper < relUpper)
                continue;
            else
                relLower = relUpper;
        } else {
            maybeFree.push([
                Math.max(relLower, minX),
                Math.max(Math.min(lower - 1, maxX), minX)
            ]);
            relLower = lower;
        }

        relUpper = upper;
        covered += relUpper - relLower;
    }

    maybeFree.shift();
    var free: number[] = [];

    if (isSecond) {
        maybeFree.forEach((item) => {
            for (let i = item[0]; i <= item[1]; i++) {
                for (let range of rowRangesCovered)
                    if (i >= range[0] && i < range[1])
                        break;
                free.push(i);
            }
        });
    }

    return {
        covered: covered,
        beacons: rowBeacons.size,
        free: free
    };
};

var solution1 = discovery(2000000, -Infinity, Infinity, false);
console.log(solution1.covered - solution1.beacons);

let maxY = 4000000;
for (let i = 0; i < maxY; i++) {
    let discover = discovery(i, 0, maxY, true);

    if (discover.covered != maxY) {
        console.log(maxY * discover.free[0] + i);
        break;
    }
}

// ! Solution A: 5838453
// ! Solution B: 12413999391794
