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
part "test_ast.dart";
part "test_tags.dart";

const DART_PATH = '/Users/freewind/dev/dart/dart-sdk/bin/dart';

main() {
  group("test_parser", test_parser);
  group("test_helper", test_helper);
  group("test_compiler", test_compiler);
  group("test_ast", test_ast);
  group("test_tags", test_tags);

  testRenderedTemplates();
}

testRenderedTemplates() {
  initializeBuiltInTags();
  final templateRoot = new Directory(path.join(path.current, "templates"));
  final compiledRoot = new Directory(path.join(path.current, "compiled"));

  if (compiledRoot.existsSync()) {
    compiledRoot.deleteSync(recursive:true);
  }

  _compileTemplates(templateRoot, compiledRoot).then((files) {
    print('Compiled ${files.length} files');
    _runTestFile('test_compiled_code.dart');
  });
}

_runTestFile(String testFilePath) {
  var fullTestFilePath = new File(path.join(path.current, testFilePath)).path;
  Process.run(DART_PATH, ['--package-root=../packages', fullTestFilePath]).then((ProcessResult pr) {
    print(pr.exitCode);
    print(pr.stdout);
    print(pr.stderr);
  });
}

_compileTemplates(Directory templateRoot, Directory compiledRoot) {
  return compileTemplateDir(templateRoot, targetDir: compiledRoot);
}
