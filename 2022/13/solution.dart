import 'dart:io';
import 'dart:convert';
import 'package:tuple/tuple.dart';

typedef Packet = dynamic;
typedef PacketPair = Tuple2<dynamic, dynamic>;
typedef PacketPairs = List<Tuple2<dynamic, dynamic>>;

void main() {
  print(getIndiciesSumOfPairsInRightOrder(checkPacketPairsOrder(loadPacketPairs())));
  print(getDecoderKey(loadLines()));
}

int getIndiciesSumOfPairsInRightOrder(List<int> orderChecks) {
  var sum = 0;
  orderChecks.asMap().forEach((idx, orderCheck) { sum += orderCheck == 1 ? idx + 1 : 0; });
  return sum;
}

List<int> checkPacketPairsOrder(PacketPairs packetPairs) => packetPairs.map((packetPair) => checkPacketPairOrder(packetPair)).toList();

int checkPacketPairOrder(PacketPair packetPair) {
  var packet1 = packetPair.item1;
  var packet2 = packetPair.item2;

  if (packet1.runtimeType == int && packet2.runtimeType == int)
    return (packet2 as int).compareTo(packet1 as int);

  if (packet1.runtimeType == List && packet2.runtimeType == int)
    return checkPacketPairOrder(Tuple2(packet1, [packet2]));

  if (packet1.runtimeType == int && packet2.runtimeType == List)
    return checkPacketPairOrder(Tuple2([packet1], packet2));

  var packet1Arr = packet1 as List<dynamic>;
  var packet2Arr = packet2 as List<dynamic>;

  int tmp = 0;

  for (var i = 0; i < packet1Arr.length; i++) {
    if (i >= packet2Arr.length)
      return -1;

    tmp = checkPacketPairOrder(Tuple2(packet1Arr[i], packet2Arr[i]));

    if (tmp != 0)
      return tmp;
  }

  if (tmp == 0 && packet1Arr.length < packet2Arr.length)
    return 1;

  return 0;
}

int getDecoderKey(List<String> lines) {
  var dividerPacket1 = "[[2]]";
  var dividerPacket2 = "[[6]]";

  lines.add(dividerPacket1);
  lines.add(dividerPacket2);
  lines.sort((a, b) => checkPacketPairOrder(createPacketPair(b, a)));

  return (lines.indexOf(dividerPacket1) + 1) * (lines.indexOf(dividerPacket2) + 1);
}

PacketPairs loadPacketPairs() => File('input.txt')
  .readAsStringSync()
  .split("\r\n\r\n")
  .map((pair) => createPacketPair(pair.split("\r\n")[0], pair.split("\r\n")[1]))
  .toList();

List<String> loadLines() => File("input.txt")
  .readAsLinesSync()
  .where((line) => line.isNotEmpty)
  .toList();

PacketPair createPacketPair(String item1, String item2) => Tuple2(jsonDecode(item1), jsonDecode(item2));

// ! Solution A: 6369
// ! Solution B: 25800
