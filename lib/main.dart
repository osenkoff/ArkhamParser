import 'dart:io';

import 'package:arkham/parser.dart';

void main() async {
  // only for test
  final file = File('bin/arkham.txt');
  final content = file.readAsStringSync();

  final result = await Parser(content).parse();
}

