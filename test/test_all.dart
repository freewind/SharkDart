library shark_tests;

import "package:unittest/unittest.dart";
import "package:petitparser/petitparser.dart";
import "../lib/shark.dart";

part "test_parser.dart";
part "test_helper.dart";

main() {
  group("test_parser", test_parser);
  group("test_helper.dart", test_helper);
}


