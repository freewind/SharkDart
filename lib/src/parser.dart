part of shark;

class SharkParser extends CompositeParser {

  @override
  void initialize() {
    grammar();
    parser();
  }

  grammar() {
    def('start', (
      ref('atAt')
      | ref('sharkTag').separatedBy(whitespace().star(), includeSeparators:false)
      | ref('sharkPlainTextTag')
      | ref('sharkExpression')
      | any()
    ).star());

    def('atAt', string('@@'));
    def('sharkTag', _block(char('@'), ref('normalBlock')));
    def('sharkPlainTextTag', _block(string('@!'), ref('plainTextBlock')));

    def('tagName', pattern(r'a-zA-Z_$').plus().flatten());
    def('tagParams', ref('multiParamArray') | ref('codeParam'));
    def('multiParamArray', (
      char('(') & ref('tagParam').separatedBy(char(','), includeSeparators:false).optional([]) & char(')')
    ).pick(1));

    def('tagParam', (
      (
        (ref('paramType').seq(whitespace().and()).flatten().trim() & ref('paramVariable').trim() )
        | (epsilon() & ref('paramVariable').trim())
      )
      & (char(':') & ref('paramDescription').trim()).optional()
    ));
    def('paramType', pattern(r'a-zA-Z_$<>').plus().flatten());
    def('paramVariable', pattern(r'0-9a-zA-Z_$./').plus().flatten());
    def('paramDescription', ref('variableExpression') | ref('numberExpression') | ref('singleString') | ref('doubleString') | ref('normalBlock'));
    def('variableExpression', ref('variable'));
    def('numberExpression', (digit() | char('.')).plus().flatten());

    def('singleString', _sharkString("'").flatten());
    def('doubleString', _sharkString('"').flatten());

    def('codeParam', (
      char('(') & (
        ref('codeParam')
        | ref('singleString')
        | ref('doubleString')
        | char(')').neg()
      ).star().flatten() & char(')')
    ).pick(1));

    def('normalBlock', new BlockParser(
      ref('atAt') | ref('sharkTag') | ref('sharkPlainTextTag') | ref('sharkExpression') | any())
    );
    def('plainTextBlock', new BlockParser(any()));

    def('sharkExpression', ref('simpleExpression') | ref('complexExpression'));
    def('simpleExpression', char('@') & ref('variable'));
    def('variable', (ref('variableHead') & (ref('variableHead') | digit()).star()).flatten());
    def('variableHead', pattern(r'a-zA-Z_$'));
    def('complexExpression', char('@') & ref('complexExpressionBody'));
    def('complexExpressionBody', (
      char('{') & (
        ref('complexExpressionBody')
        | ref('singleString')
        | ref('doubleString')
        | char('}').neg()
      ).star().flatten() & char('}')
    ).pick(1));
  }

  parser() {
    action('start', (each) => new SharkDocument(_expand(convertStringToTextNode(compress(each)))));
    action('atAt', (_) => '@');
    action('sharkTag', _sharkTag);
    action('sharkPlainTextTag', _sharkTag);
    action('tagParam', (each) {
      var paramType = each[0][0];
      var paramVariable = each[0][1];
      var paramDescription = each[1];
      if (paramDescription != null) {
        paramDescription = paramDescription[1];
      }
      return new TagParam(paramType, paramVariable, paramDescription);
    });
    action('sharkExpression', (each) {
      var expr = each[1];
      return new SharkExpression(expr);
    });
    action('codeParam', (each) {
      return [new TagParam(null, each, null)];
    });
    action('singleString', (each) => new SharkText(each.substring(1, each.length - 1).replaceAll(r"\'", "'")));
    action('doubleString', (each) => new SharkText(each.substring(1, each.length - 1).replaceAll(r'\"', '"')));
    action('numberExpression', (each) => new SharkExpression(each));
    action('variableExpression', (each) => new SharkExpression(each));
  }

  Parser _sharkString(String boundChar) {
    return (
      char(boundChar)
      & (string(r"\" + boundChar) | char(boundChar).neg()).star()
      & char(boundChar)
    );
  }

  Parser _block(Parser startMarkParser, Parser blockParser) {
    return startMarkParser & ref('tagName') & (
      (ref('tagParams').trim() & blockParser.optional())
      | (whitespace().star().trim().map((_) => null) & blockParser)
    );
  }

  List _expand(List elements) {
    var result = [];
    for (var element in elements) {
      if (element is List) {
        result.addAll(element);
      } else {
        result.add(element);
      }
    }
    return result;
  }

  _sharkTag(each) {
    var tagName = each[1];
    var tagParams = each[2][0];
    var tagDescription = each[2][1];
    return new SharkTag(tagName, tagParams, tagDescription);
  }
}

final blockStartDelimiter = char('{').plus().flatten();
final blockEndDelimiterBound = char('}').not();

class BlockParser extends Parser {

  final Parser contentParser;

  BlockParser(this.contentParser);

  @override
  Result parseOn(Context context) {
    var result = blockStartDelimiter.parseOn(context);
    if (result.isFailure) return result;

    var endParser = _createEndParser(result.value);
    var body = new CompressList();
    while (true) {
      final entry = result;

      result = endParser.parseOn(entry);
      if (result.isSuccess) {
        var elements = convertStringToTextNode(body.compress());
        return result.success(new SharkBlock(elements));
      }

      result = contentParser.parseOn(entry);
      if (result.isSuccess) {
        body.add(result.value);
        continue;
      }

      return result.success(new SharkBlock(result.value));
    }
  }

  Parser _createEndParser(String start) {
    return string(_toEndString(start)).seq(char('}').not());
  }

  String _toEndString(String capturedStart) {
    var sb = new StringBuffer();
    for (var i = 0;i < capturedStart.length;i++) {
      sb.write('}');
    }
    return sb.toString();
  }

}


