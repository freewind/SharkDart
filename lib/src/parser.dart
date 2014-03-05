part of shark;

class SharkParser extends CompositeParser {

  @override
  void initialize() {
    grammar();
    parser();
  }

  grammar() {
    def('start', (ref('atAt') | ref('sharkTag') | ref('sharkPlainTextTag') | ref('sharkExpression') | any()).star());

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
        (ref('paramType').trim() & ref('paramVariable').trim() )
        | (epsilon() & ref('paramVariable').trim())
      )
      & (char(':') & ref('paramDescription').trim()).optional()
    ));
    def('paramType', pattern(r'a-zA-Z_$<>').plus().flatten());
    def('paramVariable', pattern(r'a-zA-Z_$').plus().flatten());
    def('paramDescription', ref('expressionVariable') | ref('number') | ref('singleString') | ref('doubleString') | ref('normalBlock'));

    def('number', (digit() | char('.')).plus().flatten());
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
      ref('atAt') | ref('sharkTag') | ref('sharkPlainTextTag') | ref('sharkExpression'))
    );
    def('plainTextBlock', new BlockParser());

    def('sharkExpression', ref('simpleExpression') | ref('complexExpression'));
    def('simpleExpression', char('@') & ref('expressionVariable'));
    def('expressionVariable', pattern(r'a-zA-Z_$').plus().flatten());
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
    action('start', (each) => new SharkDocument(compress(each)));
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
      if (expr is List && expr.length == 1) {
        expr = expr.first;
      }
      return new SharkExpression(expr);
    });
    action('codeParam', (each) {
      return [new TagParam(null, each, null)];
    });
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

  _sharkTag(each) {
    var tagName = each[1];
    var tagParams = each[2][0];
    var tagDescription = each[2][1];
    return new SharkTag(tagName, tagParams, tagDescription);
  }
}

const blockStartDelimiterChar = '{';
const blockEndDelimiterChar = '}';

final blockStartDelimiter = char('{').plus().flatten();
final blockEndDelimiterBound = char('}').not();

class BlockParser extends Parser {

  final Parser nonAnyCharParser;

  BlockParser([this.nonAnyCharParser=null]);

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
        return result.success(body.compress());
      }

      if (this.nonAnyCharParser != null) {
        result = nonAnyCharParser.parseOn(entry);
        if (result.isSuccess) {
          body.add(result.value);
          continue;
        }
      }

      result = any().parseOn(entry);
      if (result.isSuccess) {
        body.add(result.value);
        continue;
      }

      return result;
    }
  }

  Parser _createEndParser(String start) {
    return string(_toEndString(start)).seq(char('}').not());
  }

  String _toEndString(String capturedStart) {
    var sb = new StringBuffer();
    for (var i = 0;i < capturedStart.length;i++) {
      sb.write(blockEndDelimiterChar);
    }
    return sb.toString();
  }

}


