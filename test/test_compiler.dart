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
  solo_test('plain text template', () {
    successCompiled('hello world', '''
      | String render() {
      |   var sb = new StringBuffer();
      |   sb.write('hello world');
      |   return sb.toString();
      | }
      ''');
  });

}
