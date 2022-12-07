import 'dart:io';
import 'package:stack/stack.dart';
import 'package:tuple/tuple.dart';

typedef CrateStacksTuple = Tuple2<List<Stack<String>>, List<Stack<String>>>;
typedef CrateStacks = List<Stack<String>>;
typedef CrateStack = Stack<String>;

void main() async {
  var lines = (await File('input.txt').readAsLines()).where((line) => line.isNotEmpty).toList();
  var delimiterLineIdx = lines.indexWhere((line) => RegExp(r'^[0-9]+$').hasMatch(line.replaceAll(" ", "")));

  var stackLines = lines.take(delimiterLineIdx).toList();
  var stacks = CrateStacksTuple(getStacks(stackLines), getStacks(stackLines));

  doMovements(lines.skip(delimiterLineIdx + 1).toList(), stacks);
  printResult(stacks);
}

void printResult(CrateStacksTuple stacks) {
  stacks.item1.forEach((stack) => stdout.write(stack.top()));
  stdout.writeln();
  stacks.item2.forEach((stack) => stdout.write(stack.top()));
  stdout.writeln();
}

void moveCrates(CrateStacksTuple stacks, int count, int from, int to) {
   CrateStack tmpStack = Stack();

   while (stacks.item1[from].isNotEmpty && count > 0) {
    count--;
    stacks.item1[to].push(stacks.item1[from].pop());
    tmpStack.push(stacks.item2[from].pop());
  }

  while (tmpStack.isNotEmpty)
    stacks.item2[to].push(tmpStack.pop());
}

void doMovements(List<String> movements, CrateStacksTuple stacks) => movements.forEach((movement) {
    var movementSplit = movement.split(" ");
    var count = int.parse(movementSplit[1]);
    var from = int.parse(movementSplit[3]) - 1;
    var to = int.parse(movementSplit[5]) - 1;

    moveCrates(stacks, count, from, to);
  });

List<String> getStackLevel(String line) => List<String>.generate((line.length + 1) ~/ 4, (index) => line[1 + index * 4]);

CrateStacks getStacks(List<String> lines) {
  CrateStacks stacks = [];

  for (var i = lines.length - 1; i >= 0; i--) {
    var currentStackLevels = getStackLevel(lines[i]);

    if (stacks.isEmpty)
      currentStackLevels.forEach((_) => stacks.add(Stack()));

    for (var j = 0; j < currentStackLevels.length; j++)
      if (currentStackLevels[j] != " ")
        stacks[j].push(currentStackLevels[j]);
  }

  return stacks;
}

// ! Solution A: TLNGFGMFN
// ! Solution B: FGLQJCMBD
