part of shark_tests;

successCompiled(String template, String expected) {
  var compiled = compile(template);
  expectSameContent(compiled.trim(), expected.trim());
}

test_compiler() {
  testCompileString();
  testCompileFiles();
}

testCompileString() {
  group('compile string', () {
    test('plain text template', () {
      successCompiled('hello world', '''
        String render({String _body_()}) {
          if (_body_ == null) {
            _body_ = () => '';
          }
          var _sb_ = new StringBuffer();
          _sb_.write('hello world');
          return _sb_.toString();
        }
      ''');
    });
    test('plain text template', () {
      successCompiled("hello 'world", '''
        String render({String _body_()}) {
          if (_body_ == null) {
            _body_ = () => '';
          }
          var _sb_ = new StringBuffer();
          _sb_.write('hello \'world');
          return _sb_.toString();
        }
      ''');
    });
  });
}

testCompileFiles() {
  group('compile file', () {
    final templateRoot = new Directory(path.join(path.current, "templates"));
    final compiledRoot = new Directory(path.join(path.current, "compiled"));

    templateRoot.listSync(recursive:true, followLinks:false).where((file) => file is File).forEach((file) {
      setUp(() {
        initializeBuiltInTags();
        idForTags = 0;
      });
      test(file.path, () {
        var callback = expectAsync0(() {
        });
        var relativePath = path.relative(file.path, from: templateRoot.path);
        var compiledFile = new File(path.join(compiledRoot.path, relativePath.replaceAll(path.extension(relativePath), ".dart")));
        compileTemplateFile(templateRoot, relativePath).then((dart) {
          var expectedDart = compiledFile.readAsStringSync();
          expectSameContent(dart, expectedDart);
          callback();
        });
      });
    });
  });
}

expectSameContent(String actual, String expected) {
  var lines1 = actual.split('\n').map((line) => line.trim());
  var lines2 = expected.split('\n').map((line) => line.trim());
  expect(lines1, orderedEquals(lines2));
}
