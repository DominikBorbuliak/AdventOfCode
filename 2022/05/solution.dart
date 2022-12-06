import 'dart:io';
import 'package:stack/stack.dart';
import 'package:tuple/tuple.dart';

typedef CrateStack = Stack<String>;
typedef CrateStacks = List<Stack<String>>;

void main() async {
  var lines = (await File('input.txt').readAsLines()).where((line) => line.isNotEmpty).toList();
  var delimiterLineIdx = lines.indexWhere((line) => RegExp(r'^[0-9]+$').hasMatch(line.replaceAll(" ", "")));

  var stackLines = lines.take(delimiterLineIdx).toList();

  var stacksA = getStacks(stackLines);
  var stacksB = getStacks(stackLines);

  var finalStacks = doMovements(lines.skip(delimiterLineIdx + 1).toList(), stacksA, stacksB);

  printResult(finalStacks.item1);
  printResult(finalStacks.item2);
}

void printResult(CrateStacks stacks) {
  stacks.forEach((stack) => stdout.write(stack.top()));
  stdout.writeln();
}

CrateStacks moveCratesByOne(CrateStacks stacks, int count, int from, int to) {
  while (stacks[from].isNotEmpty && count > 0) {
    count--;
    stacks[to].push(stacks[from].pop());
  }

  return stacks;
}

CrateStacks moveCratesAtOnce(CrateStacks stacks, int count, int from, int to) {
  CrateStack tmpStack = Stack();

  while (stacks[from].isNotEmpty && count > 0) {
    count--;
    tmpStack.push(stacks[from].pop());
  }

  while (tmpStack.isNotEmpty) {
    stacks[to].push(tmpStack.pop());
  }

  return stacks;
}

Tuple2<CrateStacks, CrateStacks> doMovements(List<String> movements, CrateStacks stacksA, CrateStacks stacksB) {
  movements.forEach((movement) {
    var movementSplit = movement.split(" ");
    var count = int.parse(movementSplit[1]);
    var from = int.parse(movementSplit[3]) - 1;
    var to = int.parse(movementSplit[5]) - 1;

    stacksA = moveCratesByOne(stacksA, count, from, to);
    stacksB = moveCratesAtOnce(stacksB, count, from, to);
  });

  return Tuple2<CrateStacks, CrateStacks>(stacksA, stacksB);
}

List<String> getStackLevel(String line) {
  return List<String>.generate((line.length + 1) ~/ 4, (index) => line[1 + index * 4]);
}

CrateStacks getStacks(List<String> lines) {
  CrateStacks stacks = [];

  for (var i = lines.length - 1; i >= 0; i--) {
    var currentStackLevels = getStackLevel(lines[i]);

    if (stacks.isEmpty) {
      currentStackLevels.forEach((_) => stacks.add(Stack()));
    }

    for (var j = 0; j < currentStackLevels.length; j++) {
      if (currentStackLevels[j] != " ") {
        stacks[j].push(currentStackLevels[j]);
      }
    }
  }

  return stacks;
}

// ! Solution A: TLNGFGMFN
// ! Solution B: FGLQJCMBD
