part of shark;

class CompilableElementType {
  static final LIBRARY = new CompilableElementType();
  static final IMPORT = new CompilableElementType();
  static final FUNCTION_PARAM = new CompilableElementType();
  static final FUNCTION_BODY_TEXT = new CompilableElementType();
  static final FUNCTION_BODY_STATEMENT = new CompilableElementType();
  static final FUNCTION_BODY_EXPRESSION = new CompilableElementType();
}

typedef String FromTemplate(CompilableTemplate);

class CompilableElement {
  CompilableElementType type;
  String content;
  FromTemplate func;

  CompilableElement(this.type, this.content);

  CompilableElement.fromTemplate(this.type, this.func);
}

class Compiler {

  Future<List<File>> compileTemplateDir(Directory templateRoot, {Directory targetDir, List<String> templateExtensions: const ['shark', 'html']}) {
    Completer _completer = new Completer<List<File>>();

    List<Future<File>> compiledFiles = [];
    templateRoot.list(recursive:true, followLinks:false).listen((event) {
      if (event is File) {
        var templateFile = event as File;
        var templateFileNameNoEx = path.basenameWithoutExtension(templateFile.path);
        var templateFileExtension = path.extension(templateFile.path);
        if (templateFileExtension.startsWith('.')) {
          templateFileExtension = templateFileExtension.substring(1);
        }
        if (templateExtensions.contains(templateFileExtension.toLowerCase())) {
          var templateDirRelativePath = path.relative(templateFile.parent.path, from: templateRoot.path);
          var templateFileRelativePath = path.relative(templateFile.path, from:templateRoot.path);
          var future = compileTemplateFile(templateRoot, templateFileRelativePath).then((dartCode) {
            var targetDartFile = new File(path.join(targetDir.path, templateDirRelativePath, '${templateFileNameNoEx}.dart'));
            if (!targetDartFile.parent.existsSync()) {
              targetDartFile.parent.createSync(recursive: true);
            }
            return targetDartFile.writeAsString(dartCode);
          });
          compiledFiles.add(future);
        }
      }
    }, onDone: () {
      Future.wait(compiledFiles).then((List<File> files) => _completer.complete(files));
    }, onError: (err) {
      _completer.completeError(err);
    });

    return _completer.future;
  }

  Future<String> compileTemplateFile(Directory root, String relativeFilePath) {
    var file = new File(path.join(root.path, relativeFilePath));
    return file.readAsString().then((template) {
      var document = parse(template);
      var compilableTemplate = new CompilableTemplate(document, root, relativeFilePath);

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
  Directory templateRootDir;
  final String relativePath;
  String libraryStatement;
  List<String> importStatements = [];
  String params;
  static const defaultBodyParam = "String implicitBody_()";
  List<_IndentCompilableElement> functionBody = [];
  String returnStatement = "";

  CompilableTemplate(SharkDocument doc, [this.templateRootDir, this.relativePath]) {
    if (this.templateRootDir == null) {
      this.templateRootDir = new Directory(path.current);
    }
    _categoryWalk(doc.toCompilable(), 0);
  }

  String generate() {
    var buffer = new StringBuffer();
    if (libraryStatement != null) {
      buffer.writeln(libraryStatement);
      buffer.writeln();
    }

    if (importStatements.isNotEmpty) {
      for (var importStmt in importStatements) {
        buffer.writeln(importStmt);
      }
      buffer.writeln();
    }

    if (params == null) {
      buffer.writeln('String render({$defaultBodyParam}) {');
    } else {
      buffer.writeln('String render({$params, $defaultBodyParam}) {');
    }
    buffer.writeln('  if (implicitBody_ == null) {');
    buffer.writeln('     implicitBody_ = () => \'\';');
    buffer.writeln('  }');
    buffer.writeln('  var _sb_ = new StringBuffer();');
    for (var item in functionBody) {
      _write(buffer, item);
    }
    buffer.writeln('  return _sb_.toString();');
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
      if (item.content != null) {
        this.importStatements.add(item.content);
      } else {
        this.importStatements.add(item.func(this));
      }
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
        buffer.writeln("_sb_.writeln('${_escapeQuotes(line)}');");
      }
      buffer.writeln("_sb_.write('${_escapeQuotes(lastLine)}');");
    } else {
      _writeIndentLevel(buffer, indentElement.indentLevel);
      buffer.writeln("_sb_.write('${_escapeQuotes(text)}');");
    }
  }

  String _escapeQuotes(String str) => str.replaceAll("'", r"\'");

  _writeStatement(StringBuffer buffer, _IndentCompilableElement indentElement) {
    _writeIndentLevel(buffer, indentElement.indentLevel);
    buffer.writeln(indentElement.element.content);
  }

  _writeExpression(StringBuffer buffer, _IndentCompilableElement indentElement) {
    var expression = indentElement.element.content;
    _writeIndentLevel(buffer, indentElement.indentLevel);
    buffer.writeln('_sb_.write($expression);');
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



