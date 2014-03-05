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

dynamic toCompilable(dynamic sharkNode) {
  if (sharkNode is SharkExpression) {
    return expr(sharkNode.expression) ;
  } else if (sharkNode is String) {
    return text(sharkNode);
  } else if (sharkNode is SharkDocument) {
    return toCompilable(sharkNode.children);
  } else if (sharkNode is SharkTag) {
    return toCompilable([sharkNode]).first;
  } else if (sharkNode is List) {
    var result = [];
    var list = sharkNode as List;
    while (list.isNotEmpty) {
      var first = list.removeAt(0);
      if (first is SharkTag) {
        var tag = (first as SharkTag);
        var tagHandler = tagRepository.find(tag.tagName);
        if (tagHandler == null) {
          throw 'No tag handler found for tag: ${tag.tagName}';
        }
        var tagHandleResult = tagHandler.handle(tag, list);
        result.add(tagHandleResult.elements);
        if (tagHandleResult.tail.isNotEmpty) {
          result.add(toCompilable(tagHandleResult.tail));
        }
        break;
      } else {
        result.add(toCompilable(first));
      }
    }
    return result;
  }
}

TagHandleResult _tagToCompilable(SharkTag tag, List nodesAfterTag) {

}

class Compiler {

  Future<String> compileTemplateFile(Directory root, String relativeFilePath) {
    var file = new File(path.join(root.path, relativeFilePath));
    return file.readAsString().then((template) {
      var document = parse(template);
      var compilableTemplate = new CompilableTemplate(document);

      var libraryName = _getLibrary(relativeFilePath);
      compilableTemplate.libraryStatement = "library shark.views.${libraryName};";
      return compilableTemplate.generate();
    });
  }

  String compileTemplateString(String template) {
    var document = parse(template);
    var compilableTemplate = new CompilableTemplate(document);
    return compilableTemplate.generate();
  }

  String _getLibrary(String relativePath) {
    var items = path.split(relativePath);
    String filename = items.removeLast();
    items.add(path.basenameWithoutExtension(filename));
    return items.join('.');
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
      buffer.writeln();
    }
    for (var importStmt in importStatements) {
      buffer.writeln(importStmt);
    }
    if (params == null) {
      buffer.writeln('String render() {');
    } else {
      buffer.writeln('String render($params) {');
    }
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
    var type = indentElement.element.type;
    if (type == CompilableElementType.FUNCTION_BODY_TEXT) {
      _writeText(buffer, indentElement);
    } else if (type == CompilableElementType.FUNCTION_BODY_EXPRESSION) {
      _writeExpression(buffer, indentElement);
    } else if (type == CompilableElementType.FUNCTION_BODY_STATEMENT) {
      _writeStatement(buffer, indentElement);
    }
  }

  _writeIndentLevel(StringBuffer buffer, int level) {
    for (var i = 0; i < level + 1; i++) {
      buffer.write('  ');
    }
  }

  _writeText(StringBuffer buffer, _IndentCompilableElement indentElement) {
    var text = indentElement.element.content;
    if (text.contains('\n')) {
      var lines = text.split('\n');
      var lastLine = lines.removeLast();
      for (var line in lines) {
        _writeIndentLevel(buffer, indentElement.indentLevel);
        buffer.writeln("sb.writeln('$line');");
      }
      buffer.writeln("sb.write('$lastLine');");
    } else {
      _writeIndentLevel(buffer, indentElement.indentLevel);
      buffer.writeln("sb.write('$text');");
    }
  }

  _writeStatement(StringBuffer buffer, _IndentCompilableElement indentElement) {
    _writeIndentLevel(buffer, indentElement.indentLevel);
    buffer.writeln(indentElement.element.content);
  }

  _writeExpression(StringBuffer buffer, _IndentCompilableElement indentElement) {
    var expression = indentElement.element.content;
    _writeIndentLevel(buffer, indentElement.indentLevel);
    buffer.writeln('sb.write($expression);');
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



