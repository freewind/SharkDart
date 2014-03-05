part of shark;

registerBuiltInTags() {
  tagRepository
    ..register('if', new IfTagHandler());
}

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
      stmt('if($condition) {'),
      toCompilable(tag.body),
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
