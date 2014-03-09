part of shark;

registerBuiltInTags() {
  tagRepository
    ..register('if', new IfTagHandler());
}

int idForTags = 0;

nextId() => idForTags++;

class TagRepository {
  var store = new Map<String, TagHandler>();

  TagHandler find(String tagName) => store[tagName];

  void register(String tagName, TagHandler handler) => store[tagName] = handler;

}

abstract class TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag);
}

class TagHandleResult {
  List<CompilableElement> elements;
  List tail;

  TagHandleResult(this.elements, this.tail);
}

class IfTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var condition = tag.tagParams.first.paramVariable;
    return new TagHandleResult([
      stmt('if ($condition) {'),
      tag.body.toCompilable(),
      stmt('}')
    ], nodesAfterTag);
  }
}

class ElseTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    return new TagHandleResult([
      stmt('else {'),
      tag.body.toCompilable(),
      stmt('}')
    ], nodesAfterTag);
  }
}

class ElseIfTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var condition = tag.tagParams.first.paramVariable;
    return new TagHandleResult([
      stmt('else if ($condition) {'),
      tag.body.toCompilable(),
      stmt('}')
    ], nodesAfterTag);
  }
}

class ForTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var main = tag.tagParams.first;
    var type = (main.paramType == null ? 'var' : main.paramType);
    var variable = main.paramVariable;
    var collections = (main.paramDescription as SharkExpression).expression;
    var indexVar = 'index_${nextId()}';
    var countVar = 'total_${nextId()}';
    return new TagHandleResult([
      stmt('if ($collections != null) {'),
      stmt('  int ${indexVar} = 0;'),
      stmt('  int ${countVar} = ${collections}.length;'),
      stmt('  for (var $variable in $collections) {'),
      stmt('    int ${variable}_index = ${indexVar};'),
      stmt('    bool ${variable}_isFirst = ${indexVar} == 0;'),
      stmt('    bool ${variable}_isLast = ${indexVar} == ${countVar} - 1;'),
      stmt('    bool ${variable}_isOdd = ${indexVar} % 2 == 1;'),
      stmt('    bool ${variable}_isEven = ${indexVar} % 2 == 0;'),
      stmt('    ${indexVar}++;'),
      tag.body.toCompilable(),
      stmt('  }'),
      stmt('}')
    ], nodesAfterTag);
  }
}

class ParamsTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var params = "";
    if (tag.tagParams.isNotEmpty) {
      params = tag.tagParams.map((param) => param.toString()).join(', ');
    }
    if (tag.hasNoBody) {
      return new TagHandleResult([
        functionParams(params),
        new SharkNodeList(nodesAfterTag).toCompilable(),
      ], []);
    } else {
      return new TagHandleResult([
        functionParams(params),
        tag.body.toCompilable(),
      ], nodesAfterTag);
    }
  }

}

class RenderTagHandler extends TagHandler {
  bool implicitBody;

  RenderTagHandler(this.implicitBody);

  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var layoutFunName = tag.tagParams.first.paramVariable;
    implicitBody = tag.getParamAsBool('implicitBody', implicitBody);

    var compilables = [];
    var layoutVar = '_shark_render_${nextId()}';
    var importPathStmt = _calcImportPath(layoutFunName, layoutVar);
    compilables.add(importPathStmt);

    List<_ParamForExtendsTag> params = tag.tagParams.sublist(1).map((param) => new _ParamForExtendsTag(
      param.paramVariable,
      "${param.paramVariable}_${nextId()}",
      param.paramDescription.toCompilable()
    )).toList();

    params.forEach((p) {
      compilables.add(stmt('var ${p.paramGeneratedVariable} = () {'));
      compilables.add(stmt('var _sb_ = new StringBuffer();'));
      compilables.add(p.paramValue);
      compilables.add(stmt('return _sb_.toString();'));
      compilables.add(stmt('}();'));
    });

    var paramStr = params.map((p) => "${p.paramName}: ${p.paramGeneratedVariable}").join(', ');
    compilables.add(stmt('_sb_.write(${layoutVar}.render($paramStr, implicitBody_ : () {'));
    compilables.add(stmt('var _sb_ = new StringBuffer();'));
    if (tag.hasNoBody && implicitBody) {
      compilables.add(new SharkNodeList(nodesAfterTag).toCompilable());
    } else {
      if (tag.body != null) {
        compilables.add(tag.body.toCompilable());
      }
    }
    compilables.add(stmt('return _sb_.toString();'));
    compilables.add(stmt('}));'));

    if (tag.hasNoBody && implicitBody) {
      return new TagHandleResult(compilables, []);
    } else {
      return new TagHandleResult(compilables, nodesAfterTag);
    }
  }

  _ImportPath _calcImportPath(String funcName, String layoutVar) {
    if (funcName.startsWith('.')) {
      return importStmt('import \'${funcName}.dart\' as $layoutVar;');
    } else {
      return importStmtFromTemplate((CompilableTemplate template) {
        var templateParentPath = new File(path.join(template.templateRootDir.path, template.relativePath)).parent.path;
        var layoutFilePath = path.join(template.templateRootDir.path, funcName);
        var relative = path.relative(layoutFilePath, from:templateParentPath);
        return 'import \'${relative}.dart\' as $layoutVar;';
      });
    }
  }
}

class _ParamForExtendsTag {
  String paramName;
  String paramGeneratedVariable;
  CompilableElement paramValue;

  _ParamForExtendsTag(this.paramName, this.paramGeneratedVariable, this.paramValue);

  toString() => '$paramName : $paramGeneratedVariable : $paramValue';
}

class _ImportPath {
  String targetFilePath;
  String asName;
}

class RenderBodyTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    return new TagHandleResult([
      expr('implicitBody_()')
    ], nodesAfterTag);
  }
}

class DartTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var content = '';
    if (!tag.body.isEmpty) {
      var trim = tag.getParamAsBool('trim');
      if (trim) {
        tag.body.trim();
      }
      content = tag.body.elements.elements.first.toString();
    }
    return new TagHandleResult([
      stmt(content),
    ], nodesAfterTag);
  }
}


