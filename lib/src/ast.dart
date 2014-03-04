part of shark;

abstract class SharkNode {

  void toString0(StringBuffer buffer);

  String toString() {
    var buffer = new StringBuffer();
    toString0(buffer);
    return buffer.toString();
  }

}

class SharkDocument extends SharkNode {
  List children;

  SharkDocument(List children) {
    this.children = children;
    _addTailsForTopLevelTags();
  }

  _addTailsForTopLevelTags() {
    for (var i = 0; i < children.length; i++) {
      var node = children[i];
      if (node is SharkTag) {
        var tag = node as SharkTag;
        tag.tail = children.sublist(i + 1);
      }
    }
  }

  @override
  void toString0(buffer) {
    for (var child in children) {
      _write(buffer, child);
    }
  }

}

class SharkTag extends SharkNode {
  String tagName;
  List<TagParam> tagParams;
  dynamic body;
  List tail;

  SharkTag(this.tagName, this.tagParams, this.body);

  void toString0(StringBuffer buffer) {
    buffer.write('$runtimeType');
    buffer.write('($tagName, ');
    buffer.write("(");
    if (tagParams != null) {
      var first = true;
      for (var param in tagParams) {
        if (!first) buffer.write(', ');
        _write(buffer, param);
        first = false;
      }
    }
    buffer.write("), ");
    buffer.write('{');
    _write(buffer, body);
    buffer.write('}');
    buffer.write(')');
  }

}

class TagParam extends SharkNode {
  String paramType;
  String paramVariable;
  dynamic paramDescription;

  TagParam(this.paramType, this.paramVariable, this.paramDescription);

  void toString0(StringBuffer buffer) {
    if (paramType != null) {
      buffer.write('$paramType ');
    }
    buffer.write(paramVariable);
    if (paramDescription != null) {
      _write(buffer, ': ');
      _write(buffer, paramDescription);
    }
  }

}

class SharkExpression extends SharkNode {
  String expression;

  SharkExpression(this.expression);

  void toString0(StringBuffer buffer) {
    buffer.write('$runtimeType($expression)');
  }

}

class Text extends SharkNode {
  String content;

  Text(this.content);

  void toString0(StringBuffer buffer) {
    buffer.write(content);
  }

}

_write(StringBuffer buffer, dynamic elements) {
  if (elements == null) return;

  if (elements is! List) {
    elements = [elements];
  }
  for (var element in elements) {
    if (element is List) {
      _write(buffer, element);
    } else if (element is SharkNode) {
      element.toString0(buffer);
    } else {
      buffer.write(element);
    }
  }
}
