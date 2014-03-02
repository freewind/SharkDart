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
  List handle(SharkTag tag);
}

class IfTagHandler extends TagHandler {
  List handle(SharkTag tag) {
    var condition = tag.tagParams.first.paramVariable;
    return [
      stmt('if($condition) {'),
      toCompilable(tag.body),
      stmt('}')
    ];
  }
}

class ParamsTagHandler extends TagHandler {
  List handle(SharkTag tag) {
    var params = "";
    if (tag.tagParams.isNotEmpty) {
      params = '{' + tag.tagParams.map((param) => param.toString()).join(', ') + '}';
    }
    return [
      functionParams(params),
      toCompilable(tag.body),
    ];
  }

}
