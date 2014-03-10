part of shark_tests;

test_ast() {
  group('SharkBlock', () {
    test('trim body', () {
      var block = _textBlock('  hello  ');
      block.trim();
      var content = block.elements.elements.first.toString();
      expect(content, equals('hello'));
    });
    test('trim multiline body', () {
      var block = _textBlock('''

      hello

      ''');
      block.trim();
      var content = block.elements.elements.first.toString();
      expect(content, equals('hello'));
    });
  });
}

SharkBlock _textBlock(String text) {
  return new SharkBlock(new SharkText(text));
}
