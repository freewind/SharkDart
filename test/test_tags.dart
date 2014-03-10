part of shark_tests;

test_tags() {
  group('PlainTextTagHandler', () {
    test('trim body', () {
      var tag = new SharkTag('any', [new TagParam(null, 'trim', new SharkExpression('true'))], _textBlock('  hello  '));
      var handleResult = new PlainTextTagHandler().handle(tag, []);
      var trimmed = handleResult.elements.first.content;
      expect(trimmed, equals('hello'));
    });
  });
}
