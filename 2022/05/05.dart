import 'dart:io';
import 'package:stack/stack.dart';

void main() async {
  File('05_input.txt').readAsLines().then((List<String> lines) {
    bool readingStacks = true;
    List<Stack<String>> stacksA = [];
    List<Stack<String>> stacksB = [];

    lines.forEach((line) {
      if (line.trim() == "")
        readingStacks = false;
      else if (readingStacks) {
        var currentStackLevels = getStackLevels(line);

        var idx = 0;
        currentStackLevels.forEach((item) {
          if (stacksA.length - 1 < idx)
            stacksA.add(Stack());
          if (stacksB.length - 1 < idx)
            stacksB.add(Stack());

          if (item.trim() != "") {
            if (isNumeric(item[1])) {
              stacksA[idx] = reverseStack(stacksA[idx]);
              stacksB[idx] = reverseStack(stacksB[idx]);
            }
            else {
              stacksA[idx].push(item[1]);
              stacksB[idx].push(item[1]);
            }
          }

            idx++;
        });
      }
      else {
        var splittedLine = line.split(" ");
        
        var moveCountA = int.parse(splittedLine[1]);
        var moveCountB = int.parse(splittedLine[1]);
        var moveFrom = int.parse(splittedLine[3]);
        var moveTo = int.parse(splittedLine[5]);

        var moveFromStackA = stacksA[moveFrom - 1];
        var moveToStackA = stacksA[moveTo - 1];

        var moveFromStackB = stacksB[moveFrom - 1];
        var moveToStackB = stacksB[moveTo - 1];

        while (moveFromStackA.isNotEmpty && moveCountA != 0) {
          moveCountA--;
          moveToStackA.push(moveFromStackA.pop());
        }

        List<String> toMoveB = [];
        while (moveFromStackB.isNotEmpty && moveCountB != 0) {
          moveCountB--;
          toMoveB.add(moveFromStackB.pop());
        }

        for (int i = toMoveB.length - 1; i >= 0; i--)
          moveToStackB.push(toMoveB[i]);
      }
    });

    var resultA = "";
    stacksA.forEach((stack) {
      resultA += stack.pop();
    });

    var resultB = "";
    stacksB.forEach((stack) {
      resultB += stack.pop();
    });

    print(resultA);
    print(resultB);
  });
}

List<String> getStackLevels(String line) {
  List<String> currentStackLevels = [];

  for (int i = 0; i < line.length; i++) {
    if (i % 4 == 0) {
      final tempItem = line.substring(i, i + 3);
      currentStackLevels.add(tempItem);
      i++;
    }
  }

  return currentStackLevels;
}

bool isNumeric(String string) {
  if (string == null || string.isEmpty) {
    return false;
  }

  final number = num.tryParse(string);

  if (number == null) {
    return false;
  }

  return true;
}

Stack<String> reverseStack(Stack<String> stack) {
  Stack<String> reversedStack = Stack();

  while (stack.isNotEmpty) {
    reversedStack.push(stack.pop());
  }

  return reversedStack;
}

// ! Solution A: TLNGFGMFN
// ! Solution B: FGLQJCMBD
