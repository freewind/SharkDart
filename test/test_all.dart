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

const DART_PATH = '/Users/freewind/dev/dart/dart-sdk/bin/dart';

main() {
  group("test_parser", test_parser);
  group("test_helper", test_helper);
  group("test_compiler", test_compiler);

  testRenderedTemplates();
}

testRenderedTemplates() {
  _compileTemplates();
  _runTestFile('test_compiled_code.dart');
}

_runTestFile(String testFilePath) {
  var fullTestFilePath = new File(path.join(path.current, testFilePath)).path;
  Process.run(DART_PATH, ['--package-root=../packages', fullTestFilePath]).then((ProcessResult pr) {
    print(pr.exitCode);
    print(pr.stdout);
    print(pr.stderr);
  });
}

_compileTemplates() {
  final templateRoot = new Directory(path.join(path.current, "templates"));
  final compiledRoot = new Directory(path.join(path.current, "compiled"));

  templateRoot.listSync(recursive:true, followLinks:false).where((file) => file is File).forEach((file) {
    setUp(() {
      initializeBuiltInTags();
      idForTags = 0;
    });
    test(file.path, () {
      var relativePath = path.relative(file.path, from: templateRoot.path);
      var compiledFile = new File(path.join(compiledRoot.path, relativePath.replaceAll(path.extension(relativePath), ".dart")));
      compileTemplateFile(templateRoot, relativePath).then((dart) {
        compiledFile.writeAsStringSync(dart);
      });
    });
  });
}
