import 'dart:io';

void main() async {
  var lines = await File('input.txt').readAsLines();
  var root = buildTree(lines);
  printResults(toList(root), root);
}

void printResults(List<Node> nodes, Node root) {
  var resultA = nodes.where((node) => !node.isFile && node.size < 100000).map((node) => node.size).reduce((sum, size) => sum + size);

  var resultB = nodes.where((node) => !node.isFile).toList();
  resultB.sort((a, b) => a.size.compareTo(b.size));

  var maxSpace = 70000000;
  var updateSize = 30000000;
  var needToFreeUp = root.size + updateSize - maxSpace;

  print(resultA);
  print(resultB.firstWhere((node) => node.size > needToFreeUp).size);
}

enum CommandType {
  none,
  cd,
  ls
}

class Node {
  String name = "";
  int size = 0;
  bool isFile = false;
  Node? parent = null;
  List<Node> subNodes = [];

  Node(String name, int size, bool isFile, List<Node> subNodes, Node? parent) {
    this.name = name;
    this.size = size;
    this.isFile = isFile;
    this.subNodes = subNodes;
    this.parent = parent;
  }
}

List<Node> toList(Node node) {
  List<Node> list = [node];
  node.subNodes.forEach((subNode) => list.addAll(toList(subNode)));
  return list;
}

Node buildTree(List<String> lines) {
  Node? root = null;
  Node? currentDirectory = null;

  for (var line in lines) {
    var commandType = getCommandType(line);
    var lineSplit = line.split(" ");

    switch (commandType) {
      case CommandType.none: {
        var size = int.tryParse(lineSplit[0]);
        currentDirectory?.subNodes.add(new Node(lineSplit[1], size ?? 0, size != null, [], currentDirectory));
        break;
      }
      case CommandType.ls: {
        break;
      }
      case CommandType.cd: {
        if (lineSplit[2] == "..") {
          currentDirectory = currentDirectory?.parent;
        } else {
          if (root == null) {
            root = new Node(lineSplit[2], 0, false, [], null);
            currentDirectory = root;
          } else {
            currentDirectory = currentDirectory?.subNodes.firstWhere((node) => node.name == lineSplit[2]);
          }
        }
        break;
      }
    }
  }

  // Not possible
  root = root ?? new Node("", 0, false, [], null);
  setSizes(root);

  return root;
}

CommandType getCommandType(String line) {
  switch (line.split(" ")[1]) {
    case "cd": return CommandType.cd;
    case "ls": return CommandType.ls;
    default: return CommandType.none;
  }
}

void setSizes(Node node) {
  node.subNodes.forEach((subNode) => setSizes(subNode));
  node.subNodes.forEach((subNode) => node.size += subNode.size);
}

// ! Solution A: 2061777
// ! Solution B: 4473403