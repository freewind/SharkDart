library shark_tests;

import "package:unittest/unittest.dart";
import "package:petitparser/petitparser.dart";
import "../lib/shark.dart";

part "test_parser.dart";
part "test_helper.dart";
part "test_compiler.dart";

main() {
  group("test_parser", test_parser);
  group("test_helper", test_helper);
  group("test_compiler", test_compiler);
}


