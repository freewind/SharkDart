part of shark;

abstract class SharkNode {

}

class SharkDocument extends SharkNode {
  List children;

  SharkDocument(List children) {
    this.children = children;
  }

  @override
  String toString() {
    return children.toString();
  }

}

class SharkTag extends SharkNode {
  String tagName;
  List<TagParam> tagParams;
  dynamic body;

  SharkTag(this.tagName, this.tagParams, this.body);

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

  String getParam(String paramKey) {
    if (tagParams == null) {
      return null;
    }
    var found = tagParams.firstWhere((param) => param.paramVariable == paramKey);
    if (found == null) {
      return null;
    }
    return found.paramDescription;
  }
}

class TagParam extends SharkNode {
  String paramType;
  String paramVariable;
  dynamic paramDescription;

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

class SharkExpression extends SharkNode {
  String expression;

  SharkExpression(this.expression);

  @override
  String toString() {
    return '$runtimeType($expression)';
  }

}

class Text extends SharkNode {
  String content;

  Text(this.content);

  @override
  String toString() {
    return content;
  }

}
