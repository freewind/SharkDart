library shark;

import "package:petitparser/petitparser.dart";

part "src/parser.dart";
part "src/ast.dart";
part "src/helper.dart";

var parser = new SharkParser();

SharkDocument parse(String input) => parser.parse(input);


