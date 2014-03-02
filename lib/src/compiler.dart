part of shark;

class CompilableElementType {
  static final LIBRARY = new CompilableElementType();
  static final IMPORT = new CompilableElementType();
  static final FUNCTION_PARAM = new CompilableElementType();
  static final FUNCTION_BODY_TEXT = new CompilableElementType();
  static final FUNCTION_BODY_STATEMENT = new CompilableElementType();
  static final FUNCTION_BODY_EXPRESSION = new CompilableElementType();
}

class CompilableElement {
  CompilableElementType type;
  String content;

  CompilableElement(this.type, this.content);
}

dynamic toCompilable(sharkNode) {
  if (sharkNode is SharkDocument) {
    return (sharkNode as SharkDocument).children.map((node) => toCompilable(node));
  } else if (sharkNode is SharkTag) {
    var tag = (sharkNode as SharkTag);
    var tagHandler = tagRepository.find(tag.tagName);
    if (tagHandler == null) {
      throw 'No tag handler found for tag: ${tag.tagName}';
    }
    return tagHandler.handle(tag);
  } else if (sharkNode is SharkExpression) {
    var sharkExpr = sharkNode as SharkExpression;
    return expr(sharkExpr.expression) ;
  } else if (sharkNode is String) {
    return text(sharkNode);
  }
}

class Compiler {

  String compileTemplateFile(File file) {

  }

  String compileTemplateString(String template) {
    var document = parse(template);
    var compilableTemplate = new CompilableTemplate(document);
    return compilableTemplate.generate();
  }

}

class CompilableTemplate {
  String libraryStatement;
  List<String> importStatements = [];
  String params;
  List<_IndentCompilableElement> functionBody = [];

  CompilableTemplate(SharkDocument doc) {
    _categoryWalk(toCompilable(doc), 0);
  }

  String generate() {
    var buffer = new StringBuffer();
    if (libraryStatement != null) {
      buffer.writeln(libraryStatement);
    }
    for (var importStmt in importStatements) {
      buffer.writeln(importStmt);
    }
    buffer.writeln('String render() {');
    buffer.writeln('  var sb = new StringBuffer();');
    for (var item in functionBody) {
      _write(buffer, item);
    }
    buffer.writeln('  return sb.toString();');
    buffer.writeln('}');
    return buffer.toString();
  }

  _categoryWalk(list, int indentLevel) {
    for (var item in list) {
      if (item is List) {
        _categoryWalk(item, indentLevel + 1);
      } else {
        _category(item, indentLevel);
      }
    }
  }

  _category(CompilableElement item, int indentLevel) {
    if (item.type == CompilableElementType.LIBRARY) {
      this.libraryStatement = item.content;
    } else if (item.type == CompilableElementType.IMPORT) {
      this.importStatements.add(item.content);
    } else if (item.type == CompilableElementType.FUNCTION_PARAM) {
      this.params = item.content;
    } else {
      this.functionBody.add(new _IndentCompilableElement(indentLevel, item));
    }
  }

  _write(StringBuffer buffer, _IndentCompilableElement indentElement) {
    _writeIndentLevel(buffer, indentElement.indentLevel);
    var item = indentElement.element;
    if (item.type == CompilableElementType.FUNCTION_BODY_TEXT) {
      _writeText(buffer, item.content);
    } else if (item.type == CompilableElementType.FUNCTION_BODY_EXPRESSION) {
      _writeExpression(buffer, item.content);
    } else if (item.type == CompilableElementType.FUNCTION_BODY_STATEMENT) {
      _writeStatement(buffer, item.content);
    }
  }

  _writeIndentLevel(StringBuffer buffer, int level) {
    for (var i = 0; i < level + 1; i++) {
      buffer.write('  ');
    }
  }

  _writeText(StringBuffer buffer, String text) {
    buffer.writeln("sb.write('$text');");
  }

  _writeStatement(StringBuffer buffer, String statement) {
    buffer.writeln(statement);
  }

  _writeExpression(StringBuffer buffer, String expression) {
    buffer.writeln('sb.write($expression)');
  }

  _indentSpaces(StringBuffer buffer, int indentLevel) {
    for (var i = 0;i < indentLevel;i++) {
      buffer.write("  ");
    }
  }

}

class _IndentCompilableElement {
  int indentLevel;
  CompilableElement element;

  _IndentCompilableElement(this.indentLevel, this.element);
}



