part of shark;

compress(List elements) {
  var compressList = new CompressList();
  for (var element in elements) {
    compressList.add(element);
  }
  return compressList.compress();
}

class CompressList {
  var list = [];
  StringBuffer _buffer = null;

  void add(dynamic element) {
    if (element is String) {
      if (_buffer == null) {
        _buffer = new StringBuffer();
      }
      _buffer.write(element);
    } else {
      if (_buffer != null) {
        list.add(_buffer.toString());
        _buffer = null;
      }
      list.add(element);
    }
  }

  dynamic compress() {
    if (_buffer != null) {
      list.add(_buffer.toString());
    }
    return list;
  }
}
