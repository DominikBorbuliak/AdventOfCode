import std/strutils
import std/algorithm

type
    Option = object
        operationOperand: string
        operationValue: string
        testDivisibleBy: int
        testThrowIfTrue: int
        testThrowIfFalse: int

proc getMonkeys(): tuple[monkeys: seq[seq[int]], options: seq[Option]] =
    var monkeys: seq[seq[int]]
    var options: seq[Option]
    var idx = 0

    for line in lines "input.txt":
        if line.contains("Monkey"):
            options.add(Option());
            monkeys.add(newSeq[int]());
        elif line.contains("Starting items:"):
            for item in line.split(": ")[1].split(", "):
                monkeys[idx].add(parseInt(item))
        elif line.contains("Operation:"):
            let operandAndValue = line.split("old ")[1].split(" ")
            options[idx].operationOperand = operandAndValue[0]
            options[idx].operationValue = operandAndValue[1]
        elif line.contains("Test:"):
            options[idx].testDivisibleBy = parseInt(line.split("by ")[1])
        elif line.contains("If true:"):
            options[idx].testThrowIfTrue = parseInt(line.split("monkey ")[1])
        elif line.contains("If false:"):
            options[idx].testThrowIfFalse = parseInt(line.split("monkey ")[1])
        elif line.isEmptyOrWhitespace():
            idx += 1

    return (monkeys, options)

proc getWorryLevel(item: int, option: Option): int =
    var value = item

    if option.operationValue != "old":
        value = parseInt(option.operationValue)

    if option.operationOperand == "*":
        return item * value

    return item + value

proc getActivityAfterNRounds(monkeys: var seq[seq[int]], options: seq[Option], n :int, useRelief: bool, productOfModulos: int): seq[int] =
    var activity = newSeq[int]()
    for _ in monkeys:
        activity.add(0)

    for i in 0..<n:
        var idx = 0

        for items in monkeys:
            for item in items:
                var worryLevel = getWorryLevel(item, options[idx])
                if (useRelief):
                    worryLevel = int(worryLevel / 3)

                # Took this idea from reddit as I am dumbo :/
                worryLevel = worryLevel mod productOfModulos

                if (worryLevel mod options[idx].testDivisibleBy) == 0:
                    monkeys[options[idx].testThrowIfTrue].add(worryLevel)
                else:
                    monkeys[options[idx].testThrowIfFalse].add(worryLevel)

            activity[idx] += len(monkeys[idx])
            monkeys[idx] = newSeq[int]()
            idx += 1

    return activity

proc getProductOfModulos(options: seq[Option]): int =
    var product = 1

    for option in options:
        product *= option.testDivisibleBy

    return product

var (monkeys1, options1) = getMonkeys()
var product1 = getProductOfModulos(options1)
var activity1 = getActivityAfterNRounds(monkeys1, options1, 20, true, product1)
activity1.sort()
echo (activity1[len(activity1) - 1] * activity1[len(activity1) - 2])

var (monkeys2, options2) = getMonkeys()
var product2 = getProductOfModulos(options2)
var activity2 = getActivityAfterNRounds(monkeys2, options2, 10000, false, product2)
activity2.sort()
echo (activity2[len(activity1) - 1] * activity2[len(activity1) - 2])

# ! Solution A: 55944
# ! Solution B: 15117269860
