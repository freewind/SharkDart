part of shark_tests;

successCompiled(String template, String expected) {
  var compiled = compile(template);
  expectSameContent(compiled.trim(), expected.trim());
}

test_compiler() {
  group('compile string', () {
    test('plain text template', () {
      successCompiled('hello world', '''
        String render({String implicitBody_()}) {
          if (implicitBody_ == null) {
            implicitBody_ = () => '';
          }
          var _sb_ = new StringBuffer();
          _sb_.write('hello world');
          return _sb_.toString();
        }
      ''');
    });
    test('plain text template', () {
      successCompiled("'hello 'world'", r'''
        String render({String implicitBody_()}) {
          if (implicitBody_ == null) {
            implicitBody_ = () => '';
          }
          var _sb_ = new StringBuffer();
          _sb_.write('\'hello \'world\'');
          return _sb_.toString();
        }
      ''');
    });
  });
}

expectSameContent(String actual, String expected) {
  var lines1 = actual.split('\n').map((line) => line.trim());
  var lines2 = expected.split('\n').map((line) => line.trim());
  expect(lines1, orderedEquals(lines2));
}
