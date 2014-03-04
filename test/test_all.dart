library shark_tests;

import "dart:io";
import "dart:async";
import "package:unittest/unittest.dart";
import "package:petitparser/petitparser.dart";
import "package:path/path.dart" as path;
import "../lib/shark.dart";

part "test_parser.dart";
part "test_helper.dart";
part "test_compiler.dart";

main() {
  group("test_parser", test_parser);
  group("test_helper", test_helper);
  group("test_compiler", test_compiler);
}


