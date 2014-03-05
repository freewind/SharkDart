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
      toCompilable(tag.body),
      stmt('}')
    ], nodesAfterTag);
  }
}

class ElseTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    return new TagHandleResult([
      stmt('else {'),
      toCompilable(tag.body),
      stmt('}')
    ], nodesAfterTag);
  }
}

class ElseIfTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var condition = tag.tagParams.first.paramVariable;
    return new TagHandleResult([
      stmt('else if ($condition) {'),
      toCompilable(tag.body),
      stmt('}')
    ], nodesAfterTag);
  }
}

class ForTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var main = tag.tagParams.first;
    var type = (main.paramType == null ? 'var' : main.paramType);
    var variable = main.paramVariable;
    var collections = main.paramDescription;
    var indexVar = 'index_${nextId()}';
    var countVar = 'total_${nextId()}';
    return new TagHandleResult([
      stmt('int ${indexVar} = 0;'),
      stmt('if ($collections != null) {'),
      stmt('  int ${indexVar} = 0;'),
      stmt('  int ${countVar} = ${collections.length};'),
      stmt('  for (var $variable in $collections) {'),
      stmt('    int ${variable}_index = ${indexVar};'),
      stmt('    bool ${variable}_isFirst = ${indexVar} == 0;'),
      stmt('    bool ${variable}_isLast = ${indexVar} == ${countVar};'),
      stmt('    bool ${variable}_isOdd = ${indexVar} % 2 == 1;'),
      stmt('    bool ${variable}_isEven = ${indexVar} % 2 == 0;'),
      stmt('    ${indexVar}++;'),
      toCompilable(tag.body),
      stmt('  }'),
      stmt('}')
    ], nodesAfterTag);
  }
}

class ParamsTagHandler extends TagHandler {
  TagHandleResult handle(SharkTag tag, List nodesAfterTag) {
    var params = "";
    if (tag.tagParams.isNotEmpty) {
      params = '{' + tag.tagParams.map((param) => param.toString()).join(', ') + '}';
    }
    if (tag.hasNoBody) {
      return new TagHandleResult([
        functionParams(params),
        toCompilable(nodesAfterTag),
      ], []);
    } else {
      return new TagHandleResult([
        functionParams(params),
        toCompilable(tag.body),
      ], nodesAfterTag);
    }
  }

}
