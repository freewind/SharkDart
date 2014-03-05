part of shark_tests;

successCompiled(String template, String expected) {
  var compiled = compile(template);
  expect(compiled.trim(), _margin(expected, '| '));
}

_margin(String text, String delimiter) {
  return text.trim().split('\n').map((line) {
    var trimmed = line.trim();
    if (trimmed.startsWith(delimiter)) {
      return trimmed.substring(delimiter.length);
    } else {
      throw 'This line is not started with $delimiter: $line';
    }
  }).join('\n');
}

test_compiler() {
  testCompileString();
  testCompileFiles();
}

testCompileString() {
  group('compile string', () {
    test('plain text template', () {
      successCompiled('hello world', '''
      | String render() {
      |   var sb = new StringBuffer();
      |   sb.write('hello world');
      |   return sb.toString();
      | }
      ''');
    });
    test('plain text template', () {
      successCompiled("hello 'world", '''
      | String render() {
      |   var sb = new StringBuffer();
      |   sb.write('hello \'world');
      |   return sb.toString();
      | }
      ''');
    });
  });
}

testCompileFiles() {
  group('compile file', () {
    final templateRoot = new Directory(path.join(path.current, "templates"));
    final compiledRoot = new Directory(path.join(path.current, "compiled"));

    templateRoot.listSync(recursive:true, followLinks:false).where((file) => file is File).forEach((file) {
      setUp(initializeBuiltInTags);
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
