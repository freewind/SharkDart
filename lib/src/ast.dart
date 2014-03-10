part of shark;

abstract class SharkNode {
  String toString();

  CompilableElement toCompilable();
}

class SharkDocument extends SharkNode {
  SharkNodeList children;

  SharkDocument(List<SharkNode> children) {
    this.children = new SharkNodeList(children);
  }

  @override
  CompilableElement toCompilable() => children.toCompilable();

  @override
  String toString() => children.toString();

}

class SharkTag extends SharkNode {
  String tagName;
  List<TagParam> tagParams;
  SharkBlock body;

  SharkTag(this.tagName, this.tagParams, this.body);

  @override
  CompilableElement toCompilable() => new SharkNodeList(this).toCompilable();

  @override
  String toString() {
    var buffer = new StringBuffer();
    buffer.write('$runtimeType');
    buffer.write('($tagName, ');

    if (hasNoParams) {
      buffer.write('<null>, ');
    } else {
      buffer.write("(");
      if (tagParams != null) {
        var first = true;
        for (var param in tagParams) {
          if (!first) buffer.write(', ');
          buffer.write(param);
          first = false;
        }
      }
      buffer.write("), ");
    }

    if (hasNoBody) {
      buffer.write('<null>');
    } else {
      buffer.write('{');
      buffer.write(body);
      buffer.write('}');
    }
    buffer.write(')');
    return buffer.toString();
  }

  bool get hasNoParams => tagParams == null;

  bool get hasNoBody => body == null;

  SharkNode getParam(String paramKey) {
    if (tagParams == null) {
      return null;
    }
    var matched = tagParams.where((param) => param.paramVariable == paramKey).toList();
    if (matched.isEmpty) {
      return null;
    }
    var found = matched.first;
    return found.paramDescription;
  }

  String getParamAsString(String paramKey, [String defaultValue]) {
    var node = getParam(paramKey);
    return node == null ? defaultValue : node.toString();
  }

  bool getParamAsBool(String paramKey, [bool defaultValue]) {
    var value = getParam(paramKey);
    if (value == null) {
      return defaultValue;
    }
    return value is SharkExpression && value.expression == 'true';
  }
}

class TagParam extends SharkNode {
  String paramType;
  String paramVariable;
  SharkNode paramDescription;

  TagParam(this.paramType, this.paramVariable, this.paramDescription);

  @override
  String toString() {
    var buffer = new StringBuffer();
    if (paramType != null) {
      buffer.write('$paramType ');
    }
    buffer.write(paramVariable);
    if (paramDescription != null) {
      buffer.write(': ');
      buffer.write(paramDescription);
    }
    return buffer.toString();
  }

}

class SharkBlock extends SharkNode {
  SharkNodeList elements;

  SharkBlock(elements) {
    if (elements is List) {
      this.elements = new SharkNodeList(elements);
    } else {
      this.elements = new SharkNodeList([elements]);
    }
  }

  @override
  CompilableElement toCompilable() => elements.toCompilable();

  @override
  String toString() => this.elements.toString();

  bool get isEmpty => elements.isEmpty;

  void trim() {
    if (elements.isEmpty) return;

    var first = elements.elements.first;
    if (first is SharkText) {
      var sharkText = first as SharkText;
      sharkText.content = _trimLeft(sharkText.content);
    }
    var last = elements.elements.last;
    if (last is SharkText) {
      var sharkText = last as SharkText;
      sharkText.content = _trimRight(sharkText.content);
    }
  }

  String _trimLeft(String str) {
    return str.replaceFirst(new RegExp(r"^[\r\n\s]+"), "");
  }

  String _trimRight(String str) {
    return str.replaceFirst(new RegExp(r"[\r\n\s]+$"), "");
  }
}

class SharkExpression extends SharkNode {
  String expression;

  SharkExpression(this.expression);

  @override
  CompilableElement toCompilable() => expr(expression);

  @override
  String toString() => '$runtimeType($expression)';

}

class SharkText extends SharkNode {
  String content;

  SharkText(this.content);

  @override
  CompilableElement toCompilable() => text(content);

  @override
  String toString() => content;

}

class SharkNodeList extends SharkNode {

  List<SharkNode> elements = [];

  SharkNodeList(this.elements);

  bool get isEmpty => elements.isEmpty;

  int get length => elements.length;

  @override
  CompilableElement toCompilable() {
    var result = [];
    List<SharkNode> list = []
      ..addAll(elements);

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
          result.add(new SharkNodeList(tagHandleResult.tail).toCompilable());
        }
        break;
      } else {
        result.add(first.toCompilable());
      }
    }
    return result;
  }

  String toString() => elements.toString();
}
