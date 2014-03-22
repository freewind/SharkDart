part of shark;

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
    var separator = tag.getParamAsString('separator', '');

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
      stmt('    if(!${variable}_isFirst) {'),
      text(separator),
      stmt('    }'),
      stmt('    ${indexVar}++;'),
      tag.body.toCompilable(),
      stmt('  }'),
      stmt('}')
    ], nodesAfterTag

    );
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
  bool enableImplicitBodyByDefault;

  RenderTagHandler(this.enableImplicitBodyByDefault);

  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    return new _RenderTagInternalHandler(tag, nodesAfterTag, this.enableImplicitBodyByDefault).handle();
  }

}

class _RenderTagInternalHandler {
  final targetTemplateVar = '_shark_render_${nextId()}';
  bool enableImplicitBody;
  List<_ParamForRenderTag> renderParams;
  SharkTag tag;
  List nodesAfterTag;

  _RenderTagInternalHandler(this.tag, this.nodesAfterTag, enableImplicitBodyByDefault) {
    this.enableImplicitBody = this.tag.getParamAsBool('enableImplicitBody', enableImplicitBodyByDefault);
    this.renderParams = _compileRenderParams();
  }

  TagHandleResult handle() {
    var compilableItems = [ buildImportPathStmt() ];
    for (var p in renderParams) {
      compilableItems.addAll(_preCalculateParamValue(p));
    }
    compilableItems.addAll(_renderTargetTemplate());

    if (tag.hasNoBody && enableImplicitBody) {
      return new TagHandleResult(compilableItems, []);
    } else {
      return new TagHandleResult(compilableItems, nodesAfterTag);
    }
  }

  _ImportPath buildImportPathStmt() {
    var targetTemplateName = tag.tagParams.first.paramVariable;
    if (targetTemplateName.startsWith('.')) {
      return importStmt('import \'${targetTemplateName}.dart\' as $targetTemplateVar;');
    } else {
      return importStmtFromTemplate((CompilableTemplate template) {
        var templateParentPath = new File(path.join(template.templateRootDir.path, template.relativePath)).parent.path;
        var targetTemplateFilePath = path.join(template.templateRootDir.path, targetTemplateName);
        var relative = path.relative(targetTemplateFilePath, from:templateParentPath);
        return 'import \'${relative}.dart\' as $targetTemplateVar;';
      });
    }
  }

  List<_ParamForRenderTag> _compileRenderParams() {
    return tag.tagParams.sublist(1).map((param) => new _ParamForRenderTag(
      param.paramVariable,
      '${param.paramVariable}_${nextId()}',
      param.paramDescription.toCompilable()
    )).toList();
  }

  List<CompilableElement> _preCalculateParamValue(_ParamForRenderTag p) {
    return [
      stmt('var ${p.paramGeneratedVariable} = () {'),
      stmt('  var _sb_ = new StringBuffer();'),
      p.paramValue,
      stmt('  return _sb_.toString();'),
      stmt('}();')
    ];
  }

  List<CompilableElement> _renderTargetTemplate() {
    var items = [];
    var paramStr = renderParams.map((p) => "${p.paramName}: ${p.paramGeneratedVariable}").join(', ');
    items.add(stmt('_sb_.write(${targetTemplateVar}.render($paramStr, implicitBody_ : () {'));
    items.add(stmt('  var _sb_ = new StringBuffer();'));
    if (tag.hasNoBody && enableImplicitBody) {
      items.add(new SharkNodeList(nodesAfterTag).toCompilable());
    } else if (tag.body != null) {
      items.add(tag.body.toCompilable());
    }
    items.add(stmt('  return _sb_.toString();'));
    items.add(stmt('}));'));
    return items;
  }

}

class _ParamForRenderTag {
  String paramName;
  String paramGeneratedVariable;
  CompilableElement paramValue;

  _ParamForRenderTag(this.paramName, this.paramGeneratedVariable, this.paramValue);

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

class PlainTextTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var content = '';
    if (tag.body != null) {
      var trim = tag.getParamAsBool('trim', false);
      if (trim) {
        tag.body.trim();
      }
      content = tag.body.elements.elements.first.toString();
    }
    return new TagHandleResult([
      text(content)
    ], nodesAfterTag);
  }
}
